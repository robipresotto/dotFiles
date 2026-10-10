#!/usr/bin/env bash
#
# tools.sh - manage tool profiles in config/tools/*.json
#
# Each profile file has a top-level "enabled" flag (defaults to true when absent).
# Only enabled profiles are installed by `tools.sh install` / install.sh.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TOOLS_DIR="${TOOLS_CONFIG_DIR:-$REPO_ROOT/config/tools}"
VSCODE_EXTENSIONS_FILE="$REPO_ROOT/config/vscode/extensions.txt"

C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_GREEN=$'\033[32m'; C_RED=$'\033[31m'
C_YELLOW=$'\033[33m'; C_GRAY=$'\033[90m'; C_CYAN=$'\033[36m'

usage() {
  cat <<EOF
Usage: tools.sh <command> [options]

Commands:
  list                          List all profiles and their enabled state
  enable <profile|all>...       Enable profiles
  disable <profile|all>...      Disable profiles
  merged [--all]                Print merged JSON (enabled profiles, --all for every profile)
  install [--dry-run] [--all] [--only p1,p2]
                                Install brew taps/formulas/casks from enabled profiles
  status [--only p1,p2]         Show installed/missing packages per profile
  vscode [--dry-run]            Install VS Code extensions from config/vscode/extensions.txt

Examples:
  tools.sh list
  tools.sh disable bio
  tools.sh enable platform database
  tools.sh install --dry-run
  tools.sh status
EOF
}

die() { echo "❌ $*" >&2; exit 1; }

require_jq() {
  command -v jq >/dev/null 2>&1 || die "jq is required. Run: brew install jq"
}

profile_files() {
  local f
  for f in "$TOOLS_DIR"/*.json; do
    [[ -f "$f" ]] || continue
    echo "$f"
  done
}

profile_name() { basename "$1" .json; }

is_enabled() {
  local file="$1"
  # NOTE: not `.enabled // true` - jq's // also treats explicit false as empty
  [[ "$(jq -r 'if .enabled == null then true else .enabled end' "$file")" == "true" ]]
}

set_enabled() {
  local file="$1" state="$2" tmp
  jq --argjson state "$state" '.enabled = $state' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

resolve_profile() {
  local name="$1" file="$TOOLS_DIR/$name.json"
  [[ -f "$file" ]] || die "Unknown profile: $name (available: $(ls "$TOOLS_DIR" | sed 's/\.json$//' | paste -sd' ' -))"
  echo "$file"
}

cmd_list() {
  require_jq
  printf "%-14s %-10s %-6s %-8s %s\n" "PROFILE" "STATE" "TAPS" "FORMULAS" "CASKS"
  local f name state word
  for f in $(profile_files); do
    name=$(profile_name "$f")
    if is_enabled "$f"; then word=$(printf '%-10s' "enabled");  state="${C_GREEN}${word}${C_RESET}"
    else                        word=$(printf '%-10s' "disabled"); state="${C_RED}${word}${C_RESET}"; fi
    printf "%-14s %-18s %-6s %-8s %s\n" "$name" "$state" \
      "$(jq '.brew.taps // [] | length' "$f")" \
      "$(jq '.brew.formulas // [] | length' "$f")" \
      "$(jq '.brew.casks // [] | length' "$f")"
  done
}

cmd_set_state() {
  require_jq
  local state="$1"; shift
  [[ $# -ge 1 ]] || die "Usage: tools.sh $state <profile|all>..."
  local name f
  for name in "$@"; do
    if [[ "$name" == "all" ]]; then
      for f in $(profile_files); do set_enabled "$f" "$state"; echo "  $(profile_name "$f") → $state"; done
    else
      f=$(resolve_profile "$name")
      set_enabled "$f" "$state"
      echo "  $name → $state"
    fi
  done
}

# Build merged JSON from selected profiles into a temp file (caller cleans up)
merge_configs() {
  local only="$1" include_disabled="$2" tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/dotfiles_tools.XXXXXX.json")
  local files=() f name
  for f in $(profile_files); do
    name=$(profile_name "$f")
    if [[ -n "$only" ]]; then
      [[ ",$only," == *",$name,"* ]] || continue
    elif [[ "$include_disabled" != "true" ]]; then
      is_enabled "$f" || continue
    fi
    files+=("$f")
  done
  if [[ ${#files[@]} -eq 0 ]]; then
    rm -f "$tmp"
    die "No profiles selected (check 'tools.sh list')"
  fi
  jq -s '{brew: {
    taps:     [.[] | .brew.taps     // [] | .[]] | unique,
    formulas: [.[] | .brew.formulas // [] | .[]] | unique,
    casks:    [.[] | .brew.casks    // [] | .[]] | unique
  }}' "${files[@]}" > "$tmp"
  echo "$tmp"
}

cmd_merged() {
  require_jq
  local include_disabled="false"
  [[ "${1:-}" == "--all" ]] && include_disabled="true"
  local merged
  merged=$(merge_configs "" "$include_disabled")
  cat "$merged"
  rm -f "$merged"
}

brew_has_formula() { brew list --formula 2>/dev/null | grep -qxF "$1"; }
brew_has_cask()   { brew list --cask   2>/dev/null | grep -qxF "$1"; }

install_brew_items() {
  local kind="$1" merged="$2" flag="$3" dry_run="$4" checked_cmd="$5"
  local item short failed=0
  echo -e "${C_BOLD}🧰 Installing brew $kind...${C_RESET}"
  while IFS= read -r item; do
    [[ -n "$item" ]] || continue
    short="${item##*/}"
    if [[ "$kind" == "taps" ]]; then
      if brew tap 2>/dev/null | grep -qxF "$item"; then
        echo -e "  ${C_GRAY}✅ tap already present: $item${C_RESET}"
      elif [[ "$dry_run" == "true" ]]; then
        echo -e "  ${C_YELLOW}[dry-run] would tap: $item${C_RESET}"
      else
        echo "  Adding tap: $item"
        brew tap "$item" || { echo -e "  ${C_RED}⚠️  failed to tap: $item${C_RESET}"; failed=$((failed+1)); }
      fi
    else
      if $checked_cmd "$short"; then
        echo -e "  ${C_GRAY}✅ $kind already installed: $item${C_RESET}"
      elif [[ "$dry_run" == "true" ]]; then
        echo -e "  ${C_YELLOW}[dry-run] would install $kind: $item${C_RESET}"
      else
        echo "  Installing $kind: $item"
        # shellcheck disable=SC2086
        brew install $flag "$item" || { echo -e "  ${C_RED}⚠️  failed to install $kind: $item${C_RESET}"; failed=$((failed+1)); }
      fi
    fi
  done < <(jq -r ".brew.$kind[]?" "$merged")
  [[ $failed -eq 0 ]] || echo -e "  ${C_YELLOW}$failed $kind item(s) failed${C_RESET}"
  return 0
}

cmd_install() {
  require_jq
  local dry_run="false" include_disabled="false" only=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) dry_run="true" ;;
      --all)     include_disabled="true" ;;
      --only)    only="${2:-}"; shift ;;
      *)         die "Unknown option: $1 (see: tools.sh --help)" ;;
    esac
    shift
  done

  local merged selected
  merged=$(merge_configs "$only" "$include_disabled")
  selected=$(jq -r '[.brew.taps[], .brew.formulas[], .brew.casks[]] | length' "$merged")
  if [[ "$dry_run" == "true" ]]; then
    echo -e "${C_CYAN}🔍 Dry run: $selected item(s) from selected profiles${C_RESET}"
  else
    echo -e "${C_CYAN}📦 Installing $selected item(s) from selected profiles...${C_RESET}"
  fi

  install_brew_items "taps"     "$merged" ""        "$dry_run" ""
  install_brew_items "formulas" "$merged" ""        "$dry_run" "brew_has_formula"
  install_brew_items "casks"    "$merged" "--cask"  "$dry_run" "brew_has_cask"

  rm -f "$merged"
  echo -e "${C_GREEN}🎉 Tool installation complete${C_RESET}"
}

cmd_status() {
  require_jq
  local only=""
  [[ "${1:-}" == "--only" ]] && { only="${2:-}"; shift 2; }
  local f name item short missing
  for f in $(profile_files); do
    name=$(profile_name "$f")
    if [[ -n "$only" ]]; then
      [[ ",$only," == *",$name,"* ]] || continue
    elif ! is_enabled "$f"; then
      continue
    fi
    echo -e "${C_BOLD}${C_CYAN}$name${C_RESET}"
    for kind in formulas casks; do
      [[ "$kind" == "formulas" ]] && checked="brew_has_formula" || checked="brew_has_cask"
      flag=""
      [[ "$kind" == "casks" ]] && flag="--cask"
      missing=""
      while IFS= read -r item; do
        [[ -n "$item" ]] || continue
        short="${item##*/}"
        $checked "$short" || missing+="$item "
      done < <(jq -r ".brew.$kind[]?" "$f")
      if [[ -n "$missing" ]]; then
        echo -e "  ${kind%?}: ${C_RED}missing →${C_RESET} $missing"
      else
        echo -e "  ${kind%?}: ${C_GREEN}all installed${C_RESET}"
      fi
    done
  done
}

cmd_vscode() {
  local dry_run="false"
  [[ "${1:-}" == "--dry-run" ]] && dry_run="true"
  [[ -f "$VSCODE_EXTENSIONS_FILE" ]] || die "Extensions file not found: $VSCODE_EXTENSIONS_FILE"
  if ! command -v code >/dev/null 2>&1; then
    echo "⚠️  'code' CLI not found. Install the VS Code shell command (Cmd+Shift+P → 'Install code command')."
    return 1
  fi
  local existing ext
  existing=$(code --list-extensions 2>/dev/null || true)
  while IFS= read -r ext; do
    [[ -n "$ext" && ! "$ext" =~ ^# ]] || continue
    if echo "$existing" | grep -qixF "$ext"; then
      echo -e "  ${C_GRAY}✅ already installed: $ext${C_RESET}"
    elif [[ "$dry_run" == "true" ]]; then
      echo -e "  ${C_YELLOW}[dry-run] would install extension: $ext${C_RESET}"
    else
      echo "  Installing extension: $ext"
      code --install-extension "$ext" >/dev/null || echo -e "  ${C_RED}⚠️  failed: $ext${C_RESET}"
    fi
  done < <(grep -v '^#' "$VSCODE_EXTENSIONS_FILE" | sed '/^\s*$/d')
  echo -e "${C_GREEN}🎨 VS Code extensions complete${C_RESET}"
}

main() {
  local cmd="${1:-help}"; shift || true
  case "$cmd" in
    list)    cmd_list ;;
    enable)  cmd_set_state true "$@" ;;
    disable) cmd_set_state false "$@" ;;
    merged)  cmd_merged "$@" ;;
    install) cmd_install "$@" ;;
    status)  cmd_status "$@" ;;
    vscode)  cmd_vscode "$@" ;;
    help|-h|--help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"

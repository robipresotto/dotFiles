# .zsh/aliases/bio.zsh

# SAMtools aliases
alias samtoolsv="samtools version"
alias bami="samtools index"
alias bams="samtools sort"
alias bamv="samtools view"
alias bamf="samtools faidx"
alias bamt="samtools tview"

# BWA aliases
alias bwai="bwa index"
alias bwam="bwa mem"
alias bwaa="bwa aln"

# BCFtools aliases
alias bcfv="bcftools view"
alias bcfc="bcftools call"
alias bcff="bcftools filter"
alias bcfn="bcftools norm"
alias bcfs="bcftools stats"

# BEDTools aliases
alias bedi="bedtools intersect"
alias bedm="bedtools merge"
alias bedc="bedtools coverage"
alias bedg="bedtools genomecov"
alias beds="bedtools sort"

# FastQC aliases
alias fqc="fastqc"
alias fqcm="fastqc -t $(sysctl -n hw.ncpu)"

# VCFtools aliases
alias vcfs="vcftools --stats"
alias vcff="vcftools --freq"
alias vcfd="vcftools --depth"

# BLAST aliases
alias blastn="blastn -num_threads $(sysctl -n hw.ncpu)"
alias blastp="blastp -num_threads $(sysctl -n hw.ncpu)"
alias blastx="blastx -num_threads $(sysctl -n hw.ncpu)"

# SeqKit aliases
alias sqk="seqkit"
alias sqks="seqkit stats"
alias sqkc="seqkit seq"
alias sqkg="seqkit grep"

# IGV aliases (if installed)
alias igv="open -a IGV"
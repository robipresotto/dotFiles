# .zsh/functions/bio.zsh

# Function to check FASTQ quality
function fqcheck() {
    local input=$1
    local output_dir="${2:-fastqc_output}"
    
    if [[ ! -f "$input" ]]; then
        echo "Error: Input file $input not found"
        return 1
    fi
    
    mkdir -p "$output_dir"
    fastqc "$input" -o "$output_dir"
    
    # Open the report if on macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        open "$output_dir/$(basename "${input%.*}")_fastqc.html"
    fi
}

# Function to convert SAM to sorted BAM
function sam2bam() {
    local input=$1
    local output="${input%.sam}.sorted.bam"
    
    samtools view -bS "$input" | \
    samtools sort -o "$output" - && \
    samtools index "$output"
    
    echo "Created sorted BAM: $output"
    echo "Created index: $output.bai"
}

# Function to get basic alignment statistics
function bamstats() {
    local input=$1
    
    echo "=== BAM Statistics for $input ==="
    echo "Total reads:"
    samtools view -c "$input"
    
    echo "\nMapped reads:"
    samtools view -F 4 -c "$input"
    
    echo "\nUnmapped reads:"
    samtools view -f 4 -c "$input"
    
    echo "\nMapping quality distribution:"
    samtools view "$input" | cut -f5 | sort | uniq -c | sort -nr
}

# Function to extract specific regions from BAM
function bambychr() {
    local input=$1
    local chr=$2
    local output="${input%.bam}_${chr}.bam"
    
    samtools view -b "$input" "$chr" > "$output"
    samtools index "$output"
}

# Function to perform quick sequence alignment
function quickalign() {
    local ref=$1
    local reads=$2
    local prefix="${reads%.fastq}"
    
    # Index reference if needed
    if [[ ! -f "${ref}.bwt" ]]; then
        bwa index "$ref"
    fi
    
    # Align
    bwa mem "$ref" "$reads" | \
    samtools view -bS - | \
    samtools sort -o "${prefix}.sorted.bam" -
    
    # Index BAM
    samtools index "${prefix}.sorted.bam"
}

# Function to convert VCF to table format
function vcf2table() {
    local input=$1
    local output="${input%.vcf}.table"
    
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\n' "$input" > "$output"
}

# Function to get FASTA sequence statistics
function fastastats() {
    local input=$1
    
    seqkit stats "$input"
}

# Function to extract sequences by IDs
function fastagrep() {
    local pattern=$1
    local input=$2
    local output="${input%.fa}_subset.fa"
    
    seqkit grep -p "$pattern" "$input" > "$output"
}

# Function to filter VCF by quality
function vcffilter() {
    local input=$1
    local qual=${2:-30}  # Default quality threshold
    local output="${input%.vcf}.filtered.vcf"
    
    bcftools filter -i "QUAL>$qual" "$input" > "$output"
}

# Function to perform quick BLAST search
function quickblast() {
    local query=$1
    local db=$2
    local output="${query%.fa}_blast.txt"
    
    blastn -query "$query" -db "$db" -outfmt 6 -out "$output"
}

# Function to calculate sequence length distribution
function seqlendist() {
    local input=$1
    
    seqkit stats -a "$input" | \
    cut -f 7 | \
    sort -n | \
    uniq -c | \
    awk '{print $2"\t"$1}'
}

# Function to extract specific chromosomes from FASTA
function extractchr() {
    local input=$1
    local chr=$2
    local output="${input%.fa}_${chr}.fa"
    
    samtools faidx "$input" "$chr" > "$output"
}
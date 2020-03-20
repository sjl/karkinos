#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

indir="./data/02-deduped-fastqs/dedupe-1"
outdir="./data/03-trimmed-fastqs"

mkdir -p $outdir

./src/log "Trimming FASTQs (using $CORES cores)..."

set -x

tail +2 sources.txt | cut -d, -f1 | while read -r sample; do
    ./src/log2 "Trimming ${sample} with Trim Galore..."

    trim_galore \
        --paired \
        --dont_gzip \
        --quality 30 \
        --stringency 5 \
        --max_n 0 \
        --cores $CORES \
        --output_dir $outdir \
        "${indir}/${sample}_1.fastq" \
        "${indir}/${sample}_2.fastq"

    mv "${outdir}/${sample}_1_val_1.fq" "${outdir}/${sample}_1.fastq"
    mv "${outdir}/${sample}_2_val_2.fq" "${outdir}/${sample}_2.fastq"
done

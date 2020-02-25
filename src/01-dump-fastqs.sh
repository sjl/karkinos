#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/01-input-fastqs

./src/log "Dumping FASTQs from input files (using $CORES cores)..."

set -x

tail +2 sources.txt | cut -d, -f1,2 | while IFS=, read -r sample runid; do
    fasterq-dump \
        --progres \
        --threads ${CORES} \
        --temp /dev/shm \
        --outdir data/01-input-fastqs \
        "data/00-raw/${runid}.1"

    mv "data/01-input-fastqs/${runid}.1_1.fastq" \
       "data/01-input-fastqs/${sample}_1.fastq"

    mv "data/01-input-fastqs/${runid}.1_2.fastq" \
       "data/01-input-fastqs/${sample}_2.fastq"
done

pigz --processes ${CORES} ./data/01-input-fastqs/*.fastq

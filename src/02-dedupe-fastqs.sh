#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/02-deduped-fastqs

./src/log "Deduplicating FASTQs (using $CORES cores)..."

set -x

for mismatches in 0 1 2
do
    ./src/log2 "Removing duplicate sequences (allowing $mismatches mismatch(es)) with ParDRe..."

    mkdir -p "data/02-deduped-fastqs/dedupe-${mismatches}/"

    tail -n +2 sources.txt | cut -d, -f1 | while IFS=, read -r sample; do
        ParDRe \
            -i "data/01-input-fastqs/${sample}_1.fastq" \
            -p "data/01-input-fastqs/${sample}_2.fastq" \
            -o "data/02-deduped-fastqs/dedupe-${mismatches}/${sample}_1.fastq" \
            -r "data/02-deduped-fastqs/dedupe-${mismatches}/${sample}_2.fastq" \
            -m $mismatches \
            -t $CORES
    done
done

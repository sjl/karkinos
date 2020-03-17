#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/02-clean-fastqs

./src/log "Cleaning FASTQs (using $CORES cores)..."

set -x

./src/log "Removing duplicate sequences with ParDRe..."
for mismatches in 0 1 2
do
    mkdir -p "data/02-clean-fastqs/dedupe-${mismatches}/"

    tail +2 sources.txt | tail +3 | cut -d, -f1 | while IFS=, read -r sample; do
        ParDRe \
            -i "data/01-input-fastqs/${sample}_1.fastq" \
            -p "data/01-input-fastqs/${sample}_2.fastq" \
            -o "data/02-clean-fastqs/dedupe-${mismatches}/${sample}_1.fastq" \
            -r "data/02-clean-fastqs/dedupe-${mismatches}/${sample}_2.fastq" \
            -m $mismatches \
            -t $CORES
    done
done

#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/04-alignment

./src/log "Aligning reads (using $CORES cores)..."

set -x

STAR \
    --runThreadN $CORES \
    --genomeDir data/03-genome-index \
    --readFilesIn \
        "$(find data/01-input-fastqs -name '*_1.fastq.gz' | sort | ./src/join ,)" \
        "$(find data/01-input-fastqs -name '*_2.fastq.gz' | sort | ./src/join ,)" \
    --readFilesCommand zcat \
    --outFileNamePrefix data/04-alignment/

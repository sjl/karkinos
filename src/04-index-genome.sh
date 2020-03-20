#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/04-genome-index

./src/log "Creating genome index (using $CORES cores)..."

set -x

STAR \
    --runThreadN $CORES \
    --runMode genomeGenerate \
    --genomeDir data/04-genome-index \
    --genomeFastaFiles data/00-raw/hg38.fa \
    --outFileNamePrefix data/04-genome-index/ \
    --sjdbGTFfile data/00-raw/hg38.ncbiRefSeq.gtf

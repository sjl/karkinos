#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/01-input-fastqs/fastqc

./src/log "Running FastQC (using $CORES cores)..."

set -x

fastqc \
    --threads ${CORES} \
    --outdir data/01-input-fastqs/fastqc \
    data/01-input-fastqs/*.fastq.gz

find data/01-input-fastqs/fastqc -name '*.zip' | xargs -n1 unzip
find data/01-input-fastqs/fastqc -name '*.zip' | xargs rm

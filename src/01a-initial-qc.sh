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

cd data/01-input-fastqs/fastqc
find . -name '*.zip' | xargs -n1 unzip
rm *.zip

grep 'Total Sequences' */fastqc_data.txt \
    | sed 's/_fastqc.*\t/ /' \
    | sort -k1,1 \
    | sort --stable -k2,2 -r \
    > totals.txt


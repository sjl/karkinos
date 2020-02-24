#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/02-clean-fastqs/fastqc

./src/log "Running FastQC (using $CORES cores)..."

set -x

# fastqc \
#     --threads ${CORES} \
#     --outdir data/02-clean-fastqs/fastqc \
#     data/02-clean-fastqs/*.fastq.gz

cd data/02-clean-fastqs/fastqc
# find . -name '*.zip' | xargs -n1 unzip
# rm *.zip

grep 'Total Sequences' */fastqc_data.txt \
    | sed 's/_fastqc.*\t/ /' \
    | sort -k1,1 \
    | sort --stable -k2,2 -n \
    > totals.txt

join <(sort ../../01-input-fastqs/fastqc/totals.txt) \
     <(sort totals.txt) \
    | sort -k 1,1 -r \
    | sort --stable -k 2,2 -n \
    > both_totals.txt

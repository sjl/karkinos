#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

./src/log "Running FastQC (using $CORES cores)..."

set -x

for mismatches in 0 1 2
do
    indir="data/02-deduped-fastqs/dedupe-${mismatches}"
    qcdir="${indir}/fastqc"

    mkdir -p "${qcdir}"

    fastqc \
        --threads ${CORES} \
        --outdir "${qcdir}" \
        "${indir}"/*.fastq

    ./src/count-fastqc-totals "${qcdir}"
done

sort data/01-input-fastqs/fastqc/totals.txt \
    | join --check-order - <(sort data/02-deduped-fastqs/dedupe-0/fastqc/totals.txt) \
    | join --check-order - <(sort data/02-deduped-fastqs/dedupe-1/fastqc/totals.txt) \
    | join --check-order - <(sort data/02-deduped-fastqs/dedupe-2/fastqc/totals.txt) \
    | sort -r \
    > data/02-deduped-fastqs/totals.txt

#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

indir="data/03-trimmed-fastqs"
qcdir="${indir}/fastqc"

mkdir -p "${qcdir}"

./src/log "Running FastQC (using $CORES cores)..."

set -x

fastqc \
    --threads ${CORES} \
    --outdir "${qcdir}" \
    "${indir}"/*.fastq


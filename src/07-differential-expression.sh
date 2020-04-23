#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

./src/log "Identifying differentially-expressed genes (using $CORES cores)..."

mkdir -p data/07-differential-expression/all
mkdir -p data/07-differential-expression/no-c3

set -x

cuffdiff \
    --num-threads $CORES \
    --output-dir "data/07-differential-expression/all" \
    --multi-read-correct \
    --labels "Normal,Cancer" \
    "data/06-transcript-assemblies/merged/merged.gtf" \
    "$(find data/05-alignment/clean/ -name 'N?.bam' | paste -sd,)" \
    "$(find data/05-alignment/clean/ -name 'C?.bam' | paste -sd,)"

cuffdiff \
    --num-threads $CORES \
    --output-dir "data/07-differential-expression/no-c3" \
    --multi-read-correct \
    --labels "Normal,Cancer" \
    "data/06-transcript-assemblies/merged/merged.gtf" \
    "$(find data/05-alignment/clean/ -name 'N?.bam' |              paste -sd,)" \
    "$(find data/05-alignment/clean/ -name 'C?.bam' | grep -v C3 | paste -sd,)"

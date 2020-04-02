#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

assemblies=data/06-transcript-assemblies/assemblies.txt

./src/log "Building transcriptome assemblies (using $CORES cores)..."

mkdir -p data/06-transcript-assemblies

set -x

rm -f $assemblies

tail +2 sources.txt | cut -d, -f1 | while read -r sample; do
    ./src/log2 "Building ${sample}..."

    outdir="data/06-transcript-assemblies/${sample}"

    cufflinks \
        --num-threads $CORES \
        --output-dir "${outdir}/" \
        "data/05-alignment/clean/${sample}/${sample}.bam"

    echo "${outdir}/transcripts.gtf" >> $assemblies
done

./src/log2 "Merging assemblies..."

cuffmerge \
    --num-threads $CORES \
    --ref-sequence data/00-raw/hg38.fa \
    --ref-gtf      data/00-raw/hg38.ncbiRefSeq.gtf \
    --output-dir  "data/06-transcript-assemblies/merged/" \
    $assemblies \
    >  data/06-transcript-assemblies/cuffmerge.out \
    2> data/06-transcript-assemblies/cuffmerge.err

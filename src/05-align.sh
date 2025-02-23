#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

./src/log "Aligning reads (using $CORES cores)..."

mkdir -p data/05-alignment

set -x

genome=data/04-genome-index
sortram=20000000000

function cleanup {
    STAR \
        --outFileNamePrefix "data/05-alignment" \
        --genomeDir "${genome}" \
        --genomeLoad Remove
}

trap cleanup EXIT

function align {
    sample=$1
    in1=$2
    in2=$3
    outdir=$4

    mkdir -p "${outdir}"

    if test -f "${outdir}/${sample}.bam"; then
        ./src/log2 "${outdir}/${sample}.bam already exists, skipping."
    else
        ./src/log2 "Aligning to ${outdir}..."
        STAR \
            --runMode alignReads \
            --runThreadN $CORES \
            --genomeDir "${genome}" \
            --genomeLoad LoadAndKeep \
            --limitBAMsortRAM "${sortram}" \
            --outSAMtype BAM SortedByCoordinate \
            --outSAMstrandField intronMotif \
            --outBAMcompression 0 \
            --outBAMsortingThreadN $CORES \
            --outFileNamePrefix "${outdir}/" \
            --readFilesIn "${in1}" "${in2}"

        mv "${outdir}/Aligned.sortedByCoord.out.bam" "${outdir}/${sample}.bam"
        samtools index -@ $CORES "${outdir}/${sample}.bam"
    fi
}

tail -n +2 sources.txt | cut -d, -f1 | while read -r sample; do
    ./src/log "Aligning ${sample}..."

    align "${sample}" \
        "data/01-input-fastqs/${sample}_1.fastq" \
        "data/01-input-fastqs/${sample}_2.fastq" \
        "data/05-alignment/dirty/${sample}"

    align "${sample}" \
        "data/03-trimmed-fastqs/${sample}_1.fastq" \
        "data/03-trimmed-fastqs/${sample}_2.fastq" \
        "data/05-alignment/clean/${sample}"
done

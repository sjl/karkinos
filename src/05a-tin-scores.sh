#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

./src/log "Computing TIN scores (using $CORES cores)..."

mkdir -p data/05-alignment/tin

set -x

tail +2 sources.txt | cut -d, -f1 | \
    xargs -I SAMPLE -n1 -P $CORES -- \
        tin.py \
            --input   data/05-alignment/clean/SAMPLE/SAMPLE.bam \
            --refgene data/00-raw/hg38_RefSeq.bed

tail +2 sources.txt | cut -d, -f1 | while read -r sample; do
    mv -t data/05-alignment/tin ${sample}.*
done

printf '# cancer\n' > data/05-alignment/tin/results

cat data/05-alignment/tin/C*.summary.txt | grep -v TIN | sed -e 's/.bam//' | sort \
    >> data/05-alignment/tin/results

printf '\n\n# normal\n' >> data/05-alignment/tin/results

cat data/05-alignment/tin/N*.summary.txt | grep -v TIN | sed -e 's/.bam//' | sort \
    >> data/05-alignment/tin/results

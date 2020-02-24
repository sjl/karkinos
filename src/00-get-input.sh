#!/usr/bin/env bash

set -euo pipefail

mkdir -p data/00-raw

./src/log "Retrieving files..."
tail +2 sources.txt | cut -d, -f3 \
    | xargs wget --continue --directory-prefix=data/00-raw

cd data/00-raw
wget 'http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz'
wget 'ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/*'

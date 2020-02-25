#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/02-clean-fastqs

overrepresented_sequence_regex='CCTCACCCGGCCCGGACACGGACAGGATTGACAGATTGATAGCTCTTTCT|CTCACCCGGCCCGGACACGGACAGGATTGACAGATTGATAGCTCTTTCTC|CTGGAGTGCAGTGGCTATTCACAGGCGCGATCCCACTACTGATCAGCACG|CTGGAGTCTTGGAAGCTTGACTACCCTACGTTCTCCTACAAATGGACCTT|CTGCCAGTAGCATATGCTTGTCTCAAAGATTAAGCCATGCATGTCTAAGT|CGGACATCTAAGGGCATCACAGACCTGTTATTGCTCAATCTCGGGTGGCT'

./src/log "Cleaning FASTQs (using $CORES cores)..."

./src/log "TODO: Figure out how to trim these reads!"
set -x

# find data/01-input-fastqs/ -name '*.fastq.gz' -printf '%f\n' \
#     | xargs -I FQ -n1 -P $CORES \
#         sh -c "zcat data/01-input-fastqs/FQ | ./src/grepv-fastq '${overrepresented_sequence_regex}' | gzip > data/02-clean-fastqs/FQ"

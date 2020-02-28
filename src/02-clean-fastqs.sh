#!/usr/bin/env bash

set -euo pipefail

CORES=${CORES:=2}

mkdir -p data/02-clean-fastqs

overrepresented_sequence_regex='CCTCACCCGGCCCGGACACGGACAGGATTGACAGATTGATAGCTCTTTCT|CTCACCCGGCCCGGACACGGACAGGATTGACAGATTGATAGCTCTTTCTC|CTGGAGTGCAGTGGCTATTCACAGGCGCGATCCCACTACTGATCAGCACG|CTGGAGTCTTGGAAGCTTGACTACCCTACGTTCTCCTACAAATGGACCTT|CTGCCAGTAGCATATGCTTGTCTCAAAGATTAAGCCATGCATGTCTAAGT|CGGACATCTAAGGGCATCACAGACCTGTTATTGCTCAATCTCGGGTGGCT'

./src/log "Cleaning FASTQs (using $CORES cores)..."

set -x

cat sources.txt | tail +2 | cut -d, -f1 \
    | xargs -I ID -n1 -P $CORES \
        bash -c "./src/filter-fastq.py '$overrepresented_sequence_regex' \
                    <(zcat data/01-input-fastqs/ID_1.fastq.gz) \
                    <(zcat data/01-input-fastqs/ID_2.fastq.gz) \
                    data/02-clean-fastqs/ID_1.fastq \
                    data/02-clean-fastqs/ID_2.fastq"

pigz data/02-clean-fastqs/*.fastq

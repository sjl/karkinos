#!/usr/bin/env bash

# set -euo pipefail

CORES=${CORES:=2}

./src/log "Finding significant differentially-expressed genes (using $CORES cores)..."

mkdir -p data/08-significant-genes

set -x

function compute {
    in="data/07-differential-expression/$1"
    out="data/08-significant-genes/$1"

    mkdir -p "$out"

    # gene_exp.diff fields:
    # 1        2        3     4      5         6         7       8        9        10                 11         12       13       14
    # test_id  gene_id  gene  locus  sample_1  sample_2  status  value_1  value_2  log2(fold_change)  test_stat  p_value  q_value  significant
    #                                                            aka      aka
    #                                                        normal_fpkm  cancer_fpkm

    #               log2fc     q               fpkm
    awk 'NR != 1 && $10 < 0 && $13 < 0.05 && ((($8 + $9) / 2) > 10) { print $1, $3, $10, $13, $8, $9 }' $in/gene_exp.diff | sort > "$out/highly-expressed-downregulated"
    awk 'NR != 1 && $10 > 0 && $13 < 0.05 && ((($8 + $9) / 2) > 10) { print $1, $3, $10, $13, $8, $9 }' $in/gene_exp.diff | sort > "$out/highly-expressed-upregulated"

    sort "$out/highly-expressed-downregulated" -nk 4 | head -100 | cut -d ' ' -f 2 > "$out/top-100-highly-expressed-downregulated"
    sort "$out/highly-expressed-upregulated"   -nk 4 | head -100 | cut -d ' ' -f 2 > "$out/top-100-highly-expressed-upregulated"
}

compute all
compute no-c3

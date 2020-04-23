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

    awk 'NR != 1 && $10 < 0 && $13 < 0.05 { print $1, $3, $10, $13 }' $in/gene_exp.diff | sort > "$out/downregulated"
    awk 'NR != 1 && $10 > 0 && $13 < 0.05 { print $1, $3, $10, $13 }' $in/gene_exp.diff | sort > "$out/upregulated"

    # genes.fpkm_tracking fields:
    # 1            2           3               4        5                6       7      8       9
    # tracking_id  class_code  nearest_ref_id  gene_id  gene_short_name  tss_id  locus  length  coverage
    #
    # 10           11              12              13
    # Normal_FPKM  Normal_conf_lo  Normal_conf_hi  Normal_status
    #
    # 14           15              16              17
    # Cancer_FPKM  Cancer_conf_lo  Cancer_conf_hi  Cancer_status
    cat "$in/genes.fpkm_tracking" | awk 'NR != 1 && (($10 + $14) / 2.0) > 10.0 { print $1, $10, $14 }' | sort > "$out/highly-expressed"

    # fields: id gene log2(fold_change) q_value normal_fpkm cancer_fpkm
    join --check-order -e NULL \
        "$out/downregulated" \
        "$out/highly-expressed" \
    > "$out/highly-expressed-downregulated"

    join --check-order -e NULL \
        "$out/upregulated" \
        "$out/highly-expressed" \
    > "$out/highly-expressed-upregulated"

    sort "$out/highly-expressed-downregulated" -nk 4 | head -100 | cut -d ' ' -f 2 > "$out/top-100-highly-expressed-downregulated"
    sort "$out/highly-expressed-upregulated"   -nk 4 | head -100 | cut -d ' ' -f 2 > "$out/top-100-highly-expressed-upregulated"
}

compute all
compute no-c3

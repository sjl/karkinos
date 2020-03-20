set terminal push
set terminal pdfcairo size 7in, 5in
set output ARG1

set termoption font ",12"

set title "Read counts of individual FASTQ files"
set xlabel "Reads (millions)"

set xtics 2
set mxtics 2

set grid y nox

set ytics left offset -2.2, 0.0

set key top left opaque box at graph 0.05, 0.95 font ",11" height 1

@bwp

data = "data/02-deduped-fastqs/totals.txt"
plot [0:35][-1:26] \
    data using ($2 / 1000000.0):0:ytic(1) title "Raw" lt 1, \
    data using ($3 / 1000000.0):0 title "Deduped (0 mismatches)"   lt 3, \
    data using ($4 / 1000000.0):0 title "Deduped (<= 1 mismatch)"  lt 4, \
    data using ($5 / 1000000.0):0 title "Deduped (<= 2 mismatches)" lt 5


set output
set terminal pop

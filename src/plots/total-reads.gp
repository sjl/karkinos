set terminal push
set terminal pdfcairo size 7in, 5in
set output ARG1

set termoption font "Routed Gothic,12"

set title "READ COUNTS OF INDIVIDUAL FASTQ FILES"
set xlabel "READS (MILLIONS)"

set xtics 2
set mxtics 2

set grid y nox

set ytics left offset -2.2, 0.0

set key bottom right opaque box at graph 0.95, 0.05

@bwp

data = "data/02-clean-fastqs/fastqc/both_totals.txt"
plot [20:35][-1:26] \
    data using ($2 / 1000000.0):0:ytic(1) title "Raw" lt 4, \
    data using ($3 / 1000000.0):0 title "After Trimming" lt 2


set output
set terminal pop

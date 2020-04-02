set terminal push
# set terminal pdfcairo size 7in,4in
set terminal pngcairo size 1000,570
set output ARG1

set termoption font ",12"

set title "TIN Scores by Sample"
set xlabel "Median TIN Score and Standard Deviation"
set ylabel "Sample"

set xtics 10

set grid y x

set key top left opaque box at graph 0.05, 0.95 width 1 height 1

@bwp

data = "data/05-alignment/tin/results"

i = 0
plot [-5:105][-13:1] \
    data index "cancer" using 3:(-$0):4:ytic(1)      with xerrorbars title "Cancer Samples" lt 1, \
    data index "normal" using 3:(-10 - $0):4:ytic(1) with xerrorbars title "Normal Samples" lt 3

set output
set terminal pop

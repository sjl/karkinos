set terminal push

set terminal pdfcairo size 7in,5in
set output "tin-scores-mp.pdf"

# set terminal pngcairo size 1000,570

set termoption font ",12"

set xtic 25
set format x ""

set ytic 0.25
set format y ""

set multiplot \
    title "TIN Score Distributions by Sample" font ",14" \
    layout 3,5

do for[c=0:9] {
    set title "C" . c
    bad = (c == 3)
    plot [][0:1] "data/05-alignment/tin/C" . c . ".tin.xls" using 5:(1) smooth cnorm notitle lw 3 \
        lc (bad ? 3 : '#000000') \
        lt (bad ? 6 : 1)
}

do for[n=1:3] {
    set title "N" . n
    bad = (n == 2 || n == 3)
    plot [][0:1] "data/05-alignment/tin/N" . n . ".tin.xls" using 5:(1) smooth cnorm notitle lw 3 \
        lc (bad ? 3 : '#000000') \
        lt (bad ? 6 : 1)
}

set multiplot next

$empty << EOF
EOF

set termoption fontscale "0.1"
set title "{/*0.9 Key}"

set ylabel "{/*0.9 CDF}"
set xlabel "{/*0.9 TIN Score}"
set format x "{/*0.9 %g}"
set format y "{/*0.9 %.2f}"

set origin 0.75,0.0
set size 0.25,0.33

plot [0:100][0:1] $empty using 1:(1) smooth cnorm notitle

unset multiplot
set output
set terminal pop

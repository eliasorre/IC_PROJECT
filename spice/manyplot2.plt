set terminal X11 noenhanced
set title "overview of circuit behavior"
set xlabel "time t[s]"
set ylabel "[v]"
set grid
unset logscale x 
set xrange [0.000000e+00:5.500000e-05]
unset logscale y 
set yrange [-7.518042e-02:1.575249e+00]
#set xtics 1
#set x2tics 1
#set ytics 1
#set y2tics 1
set format y "%g"
set format x "%g"
plot 'manyplot2.data' using 1:2 with lines lw 1 title "xdut2.vstore",\
'manyplot2.data' using 3:4 with lines lw 1 title "erase",\
'manyplot2.data' using 5:6 with lines lw 1 title "expose",\
'manyplot2.data' using 7:8 with lines lw 1 title "convert",\
'manyplot2.data' using 9:10 with lines lw 1 title "vramp",\
'manyplot2.data' using 11:12 with lines lw 1 title "xdut2.vcmp_out",\
'manyplot2.data' using 13:14 with lines lw 1 title "read"
set terminal push
set terminal postscript eps color noenhanced
set out 'manyplot2.eps'
replot
set term pop
replot

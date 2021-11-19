set terminal X11 noenhanced
set title "vstore"
set xlabel "time t[s]"
set ylabel "vstore"
set grid
unset logscale x 
set xrange [0.000000e+00:6.407060e-06]
unset logscale y 
set yrange [2.413187e-01:1.140881e+00]
#set xtics 1
#set x2tics 1
#set ytics 1
#set y2tics 1
set format y "%g"
set format x "%g"
plot 'storeplot1.data' using 1:2 with lines lw 1 title "xdut2.vstore"
set terminal push
set terminal postscript eps color noenhanced
set out 'storeplot1.eps'
replot
set term pop
replot

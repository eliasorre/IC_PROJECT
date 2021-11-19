set terminal X11 noenhanced
set title "vcmp_out"
set xlabel "time t[s]"
set ylabel "v_cmp"
set grid
unset logscale x 
set xrange [0.000000e+00:6.000000e-05]
unset logscale y 
set yrange [-7.518060e-02:1.575249e+00]
#set xtics 1
#set x2tics 1
#set ytics 1
#set y2tics 1
set format y "%g"
set format x "%g"
plot 'plots/cmp_plot.data' using 1:2 with lines lw 1 title "xdut2.vcmp_out",\
'plots/cmp_plot.data' using 3:4 with lines lw 1 title "xdut2.vstore",\
'plots/cmp_plot.data' using 5:6 with lines lw 1 title "vramp"
set terminal push
set terminal postscript eps color noenhanced
set out 'plots/cmp_plot.eps'
replot
set term pop
replot


ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor

psfsm:
	iverilog -g2012 -o pixelSensorFsm -c pixelSensorFsm.fl
	vvp -n pixelSensorFsm

array:
	iverilog -g2012 -o pixelArray -c pixelArray.fl
	vvp -n pixelArray

pixelTop:
	iverilog -g2012 -o pixelTop -c pixelTop.fl
	vvp -n pixelTop

ystop: synth
	dot pixelTop.dot -Tpng > pixelTop.png

synth:
	yosys pixelTop.ys


test: ps psfsm synth

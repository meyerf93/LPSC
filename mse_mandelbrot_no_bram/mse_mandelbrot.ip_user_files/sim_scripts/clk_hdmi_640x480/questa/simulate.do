onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_hdmi_640x480_opt

do {wave.do}

view wave
view structure
view signals

do {clk_hdmi_640x480.udo}

run -all

quit -force
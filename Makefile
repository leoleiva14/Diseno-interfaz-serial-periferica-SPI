tarea: testbench.v
	iverilog -o resultado Testbench.v
	vvp resultado
	gtkwave resultados.vcd

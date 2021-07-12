action = "simulation"
sim_tool = "ghdl"
sim_top = "mult_tb"

sim_post_cmd = "ghdl -r mult_tb --stop-time=6us --vcd=mult_tb.vcd && gtkwave mult_tb.vcd"

modules = {
  "local" : [ "../testbench" ],
}

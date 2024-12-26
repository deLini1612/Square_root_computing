set_time_format -unit ns -decimal_places 3
create_clock -name {clk} -period 105 [get_ports {clk}]

set_input_delay -clock clk 2.0 [all_inputs]
set_output_delay -clock clk 0.0 [all_outputs]
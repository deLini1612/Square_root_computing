export ROOT_DIR := $(shell pwd)
export SYN_DIR := $(ROOT_DIR)/syn
export SRC_DIR := $(ROOT_DIR)/src
export SIM_DIR:= $(ROOT_DIR)/sim
export SDC_DIR:= $(ROOT_DIR)/sdc
export SCRIPT_DIR := $(ROOT_DIR)/script

SIM_SCRIPT :=$(SCRIPT_DIR)/run_sim.sh
TEST_NUMBER := 50

SIM_ARGS_1 := $(TEST_NUMBER) a1 tb_square_root1.vhd square_root_a1.vhd
SIM_ARGS_2 := $(TEST_NUMBER) a2 tb_square_root1.vhd square_root_a2.vhd
SIM_ARGS_3 := $(TEST_NUMBER) a3 tb_square_root3.vhd square_root_a3.vhd
SIM_ARGS_4 := $(TEST_NUMBER) a4 tb_square_root4.vhd square_root_a4.vhd

all:
	@echo "  make sim_a<ARC_NUM>  				- Run simulation for the corresponding architecture"
	@echo "  make syn_a<ARC_NUM>  				- Run synthesis for the corresponding architecture"
	@echo "  make a<ARC_NUM>      				- Run both simulation and synthesis for the corresponding architecture"
	@echo "  make view_wave_a<ARC_NUM> 			- View the waveform for the corresponding architecture (run sim first)"
	@echo "Valid <ARC_NUM>: 1, 2, 3, 4, 5"

sim_a1:
	bash $(SIM_SCRIPT) $(SIM_ARGS_1)

syn_a1:
	mkdir -p $(SYN_DIR)/a1
	quartus_sh -t $(SCRIPT_DIR)/syn_a1.tcl

a1: sim_a1 syn_a1

view_wave_a1: sim_a1
	vsim -view $(SIM_DIR)/a1/a1.wlf -do $(SCRIPT_DIR)/a1.do

sim_a2:
	bash $(SIM_SCRIPT) $(SIM_ARGS_2)

syn_a2:
	mkdir -p $(SYN_DIR)/a2
	quartus_sh -t $(SCRIPT_DIR)/syn_a2.tcl

a2: sim_a2 syn_a2

view_wave_a2: sim_a2
	vsim -view $(SIM_DIR)/a2/a2.wlf -do $(SCRIPT_DIR)/a2.do

sim_a3:
	bash $(SIM_SCRIPT) $(SIM_ARGS_3)

syn_a3:
	mkdir -p $(SYN_DIR)/a3
	quartus_sh -t $(SCRIPT_DIR)/syn_a3.tcl

a3: sim_a3 syn_a3

view_wave_a3: sim_a3
	vsim -view $(SIM_DIR)/a3/a3.wlf -do $(SCRIPT_DIR)/a3.do

sim_a4:
	bash $(SIM_SCRIPT) $(SIM_ARGS_4)

syn_a4:
	mkdir -p $(SYN_DIR)/a4
	quartus_sh -t $(SCRIPT_DIR)/syn_a4.tcl

a4: sim_a4 syn_a4

view_wave_a4: sim_a4
	vsim -view $(SIM_DIR)/a4/a4.wlf -do $(SCRIPT_DIR)/a4.do
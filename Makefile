export ROOT_DIR := $(shell pwd)
export SYN_DIR := $(ROOT_DIR)/syn
export SRC_DIR := $(ROOT_DIR)/src
export SIM_DIR := $(ROOT_DIR)/sim
export SDC_DIR := $(ROOT_DIR)/sdc
export SCRIPT_DIR := $(ROOT_DIR)/script

SIM_SCRIPT := $(SCRIPT_DIR)/run_sim.sh
TEST_NUMBER := 50

# List of valid architecures
VALID_ARCHS := 1 2 3 4 5

# List of sim source for each arch
SIM_SRC1 := tb_square_root1.vhd square_root_a1.vhd
SIM_SRC2 := tb_square_root1.vhd square_root_a2.vhd
SIM_SRC3 := tb_square_root3.vhd square_root_a3.vhd
SIM_SRC4 := tb_square_root4.vhd square_root_a4.vhd
SIM_SRC5 := tb_square_root1.vhd square_root_a5.vhd

all:
	@echo "  make sim<ARC_NUM>  	- Run simulation for the corresponding architecture"
	@echo "  make syn<ARC_NUM>  	- Run synthesis for the corresponding architecture"
	@echo "  make a<ARC_NUM>      	- Run both simulation and synthesis for the corresponding architecture"
	@echo "  make wave<ARC_NUM> 	- View the waveform for the corresponding architecture (run sim first)"
	@echo "  make view_rpt<ARC_NUM> - View Quartus compilation report the corresponding architecture (run sim first)"
	@echo "  make run_sim 			- Run simulation for all architectures"
	@echo "  make sun_syn 			- Run synthesis for all architectures"
	@echo "Valid <ARC_NUM>: $(VALID_ARCHS)"

# Simulation rules (sim<ARC_NUM>)
sim%:
	$(call check_valid_arch,$*)
	$(eval SRC_FILES := $(SIM_SRC$*))
	bash $(SIM_SCRIPT) $(TEST_NUMBER) a$* $(SRC_FILES)

# Synthesis rules (syn<ARC_NUM>)
syn%:
	$(call check_valid_arch,$*)
	mkdir -p $(SYN_DIR)/a$*
	quartus_sh -t $(SCRIPT_DIR)/syn_a$*.tcl

# View waveform rules (wave<ARC_NUM>)
wave%: sim%
	$(call check_valid_arch,$*)
	vsim -view $(SIM_DIR)/a$*/a$*.wlf -do $(SCRIPT_DIR)/a$*.do

# View reports (view_rpt<ARC_NUM>)
view_rpt%:
	$(call check_valid_arch,$*)
	@if [ -f $(SYN_DIR)/a$*/output_files/square_root.cmp.rpt.htm ]; then \
		echo "Opening report for architecture a$*..."; \
		firefox $(SYN_DIR)/a$*/output_files/square_root.cmp.rpt.htm & \
	else \
		echo "To view report, run synthesis first using 'make syn$*'"; \
	fi

# Combined simulation and synthesis (a<ARC_NUM>)
a%: sim% syn%
	$(call check_valid_arch,$*)

# Run simulation for all architectures
run_sim:
	@for arch in $(VALID_ARCHS); do \
		$(MAKE) sim$$arch -C $(ROOT_DIR) -s || exit 1; \
	done

# Run synthesis for all architectures
run_syn:
	@for arch in $(VALID_ARCHS); do \
		$(MAKE) syn$$arch -C $(ROOT_DIR) -s || exit 1; \
	done

# Check if the architecture is valid
check_valid_arch = $(if $(filter $*, $(VALID_ARCHS)),, $(error Invalid architecture: $*. Valid options are: $(VALID_ARCHS)))
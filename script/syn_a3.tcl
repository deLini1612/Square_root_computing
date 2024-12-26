package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

set src_dir $env(SRC_DIR)
set sdc_file $env(SDC_DIR)/square_root3.sdc
set project_dir $env(SYN_DIR)/a3

cd $project_dir

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "syn_a3"]} {
		puts "Project syn_a3 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists syn_a3]} {
		project_open -revision square_root_reg syn_a3
	} else {
		project_new -revision square_root_reg syn_a3
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CGXFC7C7F23C8
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.1.1
	set_global_assignment -name LAST_QUARTUS_VERSION "21.1.1 Standard Edition"
	set_global_assignment -name VHDL_FILE $src_dir/square_root_a3.vhd
	set_global_assignment -name VHDL_FILE $src_dir/square_root_a3_reg.vhd
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name SDC_FILE $sdc_file

}

# Run the synthesis (compile the project)
load_package flow
execute_flow -compile

# Close project
if {$need_to_close_project} {
	project_close
}
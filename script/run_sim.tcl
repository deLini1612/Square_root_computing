set arch_name $env(ARCHITECTURE)
set project_dir $env(SIM_DIR)/$arch_name
set src_dir $env(SRC_DIR)
set desgin_files $env(DESIGN_FILES)
set testbench_file $env(TESTBENCH_FILE)
set do_file $env(DO_FILE)

# Derived variables
set project_name $arch_name
set library_name "work"

# Create a new project
if { [file exists "$arch_name.mpf"] } {
    puts "Project $arch_name already exists, opening..."
    project open $arch_name
} else {
    puts "Creating new project $arch_name"
    # Create a new project
    project new $project_dir $project_name
}

# Add files to the project
foreach file $desgin_files {
    project addfile "$src_dir/$file"
}
project addfile "$src_dir/$testbench_file"

# Set the default library
vlib $library_name

# Compile all files in the project
foreach file $desgin_files {
    vcom -work work -explicit -vopt "$src_dir/$file"
}
vcom -work work -explicit -vopt "$src_dir/$testbench_file"

vsim -voptargs=+acc -c -wlf "$arch_name.wlf" work.tb_square_root

if {$arch_name ne "a3"} {
    add wave -position end  sim:/tb_square_root/clk
    add wave -position end  sim:/tb_square_root/reset
    add wave -position end  sim:/tb_square_root/StopSim
    add wave -position end  sim:/tb_square_root/start
    add wave -position end  sim:/tb_square_root/finished
}
add wave -position end  sim:/tb_square_root/A
add wave -position end  sim:/tb_square_root/result

restart
run -all
exit
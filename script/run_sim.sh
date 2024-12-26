#!/bin/bash

# Exit immediately if a command exits with a non-zero status or if an undefined variable is used
set -eu

# Check and get passed argument for command
if [ $# -lt 3 ]; then
    echo -e "\033[31mError: Usage: $0 <TEST_NUMBER> <ARCHITECTURE> <TESTBENCH_FILE> <DESIGN_FILES>\033[0m"
    exit 1
fi
TEST_NUMBER=$1
export ARCHITECTURE=$2
export TESTBENCH_FILE=$3
shift 3
export DESIGN_FILES="$@"

# Set up sim parameter
PYTHON_SCRIPT="$SRC_DIR/randomize_input.py"
SIM_PROJECT_DIR="$SIM_DIR/$ARCHITECTURE"
TCL_FILE="$SCRIPT_DIR/run_sim.tcl"
export DO_FILE="$SCRIPT_DIR/$ARCHITECTURE"

# Update number of tests in testbench
if ! sed -i "15s/.*/    constant NUM_TEST   : integer   := $TEST_NUMBER;/" "$SRC_DIR/$TESTBENCH_FILE"; then
    echo -e "\033[31mError: Failed to update testbench test number.\033[0m"
    exit 1
fi

if [ -e "$SIM_PROJECT_DIR" ]; then
    cd "$SIM_PROJECT_DIR"
else
    mkdir -p "$SIM_PROJECT_DIR"
    cd "$SIM_PROJECT_DIR"
fi

if ! python3 "$PYTHON_SCRIPT" "$TEST_NUMBER" "$SIM_PROJECT_DIR"; then
    echo -e "\033[31mError: Failed to run Python script to generate input, golden output: $PYTHON_SCRIPT\033[0m"
    exit 1
fi

if ! vsim -c -do $TCL_FILE; then
    echo -e "\033[31mError: Simulation failed.\033[0m"
    exit 1
fi
import random
import math
import argparse

# Function to generate random 64-bit integers
def generate_random_64bit_numbers(count):
    return [random.randint(0, 2**64 - 1) for _ in range(count)]

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Generate random 64-bit integers and their floored square roots.")
    parser.add_argument("test_num", type=int, help="Number of test cases to generate.")
    parser.add_argument("sim_dir", type=str, help="Path to simulation dir.")

    # Parse arguments
    args = parser.parse_args()
    test_num = args.test_num
    sim_dir_path = args.sim_dir
    input_file_path = sim_dir_path+"/input.txt"
    golden_output_file_path = sim_dir_path+"/golden_output.txt"

    # Generate the random numbers
    random_numbers = generate_random_64bit_numbers(test_num)

    # Write the random numbers to the input file
    with open(input_file_path, "w") as input_file:
        for number in random_numbers:
            number = format(number, 'b').zfill(64)
            input_file.write(f"{number}\n")

    # Compute the square roots (floored) of the random numbers
    square_roots = [math.isqrt(number) for number in random_numbers]

    # Write the square roots to the golden output file
    with open(golden_output_file_path, "w") as output_file:
        for root in square_roots:
            root = format(root, 'b').zfill(32)
            output_file.write(f"{root}\n")

if __name__ == "__main__":
    main()

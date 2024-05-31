import torch
import time

t = 1000000

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"using device: {device}")

# Define the larger tensor shape and the smaller tensor
large_shape = (10, 10000)
#small = torch.randint(0, 10, (10, 50), device=device)

# Using the repeat and slice method
start_time = time.time()
for i in range(t):

    small = torch.randint(0, 10, (10, 50), device=device)

    # Calculate the number of repeats needed
    repeats = (large_shape[1] // small.shape[1]) + 1

    # Repeat the smaller tensor
    repeated = small.repeat(1, repeats)

    # Slice the repeated tensor to match the shape of the larger tensor
    result_repeat = repeated[:, :large_shape[1]]

repeat_time = time.time() - start_time

# Using the concatenation method
start_time = time.time()
for i in range(t):

    small = torch.randint(0, 10, (10, 50), device=device)

    # Create a list of repeated small tensor segments
    repeated_list = [small] * repeats

    # Concatenate along the second dimension
    concatenated = torch.cat(repeated_list, dim=1)

    # Slice to match the target shape
    result_concat = concatenated[:, :large_shape[1]]

concat_time = time.time() - start_time

# Print the results
print(f"Time taken using repeat and slice method: {repeat_time:.6f} seconds")
print(f"Time taken using concatenate method: {concat_time:.6f} seconds")
print(f"Result shapes are equal: {result_repeat.shape == result_concat.shape}")
print(f"Shapes: {result_repeat.shape}")


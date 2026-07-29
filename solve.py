from amplpy import AMPL
from data import variables
import time

# 1. Record the start time
start_time = time.perf_counter()


run_type = "normal"
product_codes, demand, ISL, current_stock = variables(run_type)

ampl = AMPL()

ampl.read("production.mod")

# Sets
ampl.set["PRODUCTS"] = product_codes
ampl.set["WEEKS"] = list(range(12))

# Parameters
ampl.param["isl"] = ISL
ampl.param["current_stock"] = current_stock
ampl.param["demand"] = demand

# Solver
ampl.option["solver"] = "gurobi"

# Use AMPL/MP hierarchical objectives
ampl.option["mp_options"] = "obj:multi=2 outlev=1"

ampl.solve()

###########################################################
# Retrieve results
###########################################################

inventory = ampl.get_variable("inventory").to_pandas()

batches = ampl.get_variable("batches").to_pandas()

backorder = ampl.get_variable("back_order").to_pandas()


###################################################

# 2. Record the end time
end_time = time.perf_counter()

# 3. Calculate total duration in seconds
total_seconds = end_time - start_time

# 4. Convert to minutes and seconds
minutes = int(total_seconds // 60)
seconds = int(total_seconds % 60)

# 5. Print the formatted result
print(f"Execution time: {minutes} minutes and {seconds} seconds")

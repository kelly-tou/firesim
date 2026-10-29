# Clock-domain-crossing constraints for the QSFP/Aurora links.
#
# The Aurora 64b66b cores run their user logic on txoutclk/rxoutclk (234.375 MHz, derived from
# the 156.25 MHz QSFP reference clocks). Every data path between that domain and the rest of the
# shell goes through asynchronous FIFOs (axis_clock_converter, ACLK_ASYNC=1) and the Aurora
# init_clk/user_clk crossings are synchronized inside the IP and the driver, so these clocks are
# unrelated to the host/PCIe/DDR/init clocks. Without this declaration Vivado times the
# crossings as synchronous (requirement ~0.04 ns) and the build fails by >4 ns.
#
# A set_clock_groups with a single -group makes that group asynchronous to every other clock in
# the design (UG903), which avoids having to enumerate the host-side clocks. QSFP0 and QSFP1 use
# separate reference clock inputs, so they are also asynchronous to each other.
# Processed LATE so that host_clock (FireSim-generated.implementation.xdc) and the GT-derived
# clocks already exist.
set_clock_groups -asynchronous -name qsfp0_async -group [get_clocks -include_generated_clocks qsfp0_refclk]
set_clock_groups -asynchronous -name qsfp1_async -group [get_clocks -include_generated_clocks qsfp1_refclk]

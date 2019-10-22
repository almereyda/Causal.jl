# This file illustrates the simulation of a network consisting of dynamic systesm.

using Jusdl 
using Plots 

# Simulation settings 
t0 = 0
dt = 0.01
tf = 10.

# Define the network parameters 
numnodes = 2
nodes = [LorenzSystem(Bus(3), Bus(3)) for i = 1 : numnodes]
conmat = [-10 10; 10 -10]
cplmat = [1 0 0; 0 0 0; 0 0 0]
net = Network(nodes, conmat, cplmat)
writer = Writer(Bus(length(net.output)))

# Connect the blocks
connect(net.output, writer.input)

# Construct the model 
model = Model(net, writer)

initialize(model)
set!(model.clk, t0, dt, tf)
run(model)
release(model)
terminate(model)
# Simulate the model 
# sim = simulate(model, t0, dt, tf)


model.taskmanager.pairs[net]

# # Read and process the simulation data.
# t, x = read(writer, flatten=true)
# p1 = plot(t, x[:, 1])
#     plot!(t, x[:, 4])
# p2 = plot(t, abs.(x[:, 1] - x[:, 4]))
# display(plot(p1, p2, layout=(2,1)))

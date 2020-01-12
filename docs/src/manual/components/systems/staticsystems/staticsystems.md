# StaticSystems

## Basic Operation of StaticSystems 
Static systems are the systems whose output `y` at time `t` depends on the current time `t` and the value of their inputs `u`. The input-output relation of static systems are represented by their output function `outputfunc` which is of the form 
```math 
    y = g(u, t)
```
where `g` is the output function `outputfunc`. Note that `outputfunc` is expected to have two inputs, the value `u` of the `input` and the current time `t`. The simulation in `Jusdl` is a clocked-simulation, that is the data flowing through the input and output connections of components is actually sampled at time `t`. Therefore, for example, the system modelled by
```math 
y(t) = g(u(t),t)
```
is actually sampled at clock ticks `t` which is generated by a [`Clock`](@ref). Therefore the sampled system corresponds to
```math 
y[k] = g(u_k, t_k)
```
where ``k`` is ``k_i T_s`` where ``k_i`` is an integer number, ``T_s`` is the sampling interval. ``T_s`` corresponds to sampling time `dt` of [`Clock`](@ref). Thus, the system given above is coded like 
```julia
function g(u, t)
    # Define the relation `y = g(u, t)`
end
```

For further clarity, let us continue with a case study. Consider the following static system,
```math 
    y(t) = g(u(t), t) = \left[
        \begin{array}{l}
            t u_1(t) \\
            sin(u_1(t)) \\ 
            cos(u_2(t))
        \end{array}
        \right]
```
Note that the number of inputs is 2 and the number of outputs of is 3. To define such a system, the output function is written as
```@repl static_system_ex
using Jusdl # hide
g(u, t) = [t * u[1], sin(u[1]), cos(u[2])]
```
Note that the function `g` is defined such a way that the input value `u` is sampled, which implies `u` is not vector of function but is a vector of real. Having defined output function `outputfunc`, the system can be constructed. 
```@repl static_system_ex
ss = StaticSystem(Bus(2), Bus(3), g)
```
Note the construction of input bus `Bus(2)` and output bus `Bus(3)` by recalling that the number of input is 2 and the number of output is 3.

A `StaticSystem` operates by being triggered from its `trigger` link. When triggered from its `trigger` link, a `StaticSystem` read the current time `t` from its `trigger` link and computes its output `y` according to its output function `outputfunc` and writes its output `t` to its `output` bus (If `output` bus exists since `output` bus may not have depending on the relation defined by `outputfunc`. When constructed, a `StaticSystem` is not ready to be triggered since its `trigger` link is not writeable. 
```@repl static_system_ex
ss.trigger
```
To make `ss` drivable, we need to launch `ss`. 
```@repl static_system_ex 
task = launch(ss)
```
Now, `ss` is drivable from its `trigger` link. 
```@repl static_system_ex
ss.trigger
```
Now let us drive `ss`.
```@repl static_system_ex 
put!(ss.trigger, 1.)
```
As this point `ss` wait for its to be written. Let us write some data to `input` of `ss`.
```@repl static_system_ex 
put!(ss.input, [10., 10.])
```
`ss` read the value `u` of its `input` , read the current time `t`, and computed its output value `y` and wrote it its `output`. To signal that it succeeded to be take the step, it put a `true` to its handshake which needs to be taken.
```@repl static_system_ex 
ss.handshake
take!(ss.handshake)
```
We can see the current data in the `output` of `ss`.
```@repl static_system_ex 
println(ss.output[1].buffer.data)
```
Let us further drive `ss`.
```@repl static_system_ex 
for t in 2. : 10.
    put!(ss.trigger, t)
    put!(ss.input, [10 * t, 20 * t])
    take!(ss.handshake)
end
```
The data written to the `output` of `ss` is also written to the internal buffers of `output`.
```@repl static_system_ex 
println(ss.output[1].buffer.data)
```

## Full API 
```@docs 
StaticSystem 
Adder
Multiplier
Gain
Terminator
Memory
Coupler
```
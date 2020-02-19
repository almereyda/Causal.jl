# This file includes RODESystems

import ....Components.ComponentsBase: @generic_system_fields, @generic_dynamic_system_fields, AbstractRODESystem

const RODEAlg = RandomEM()
# const RODENoise = Noise(WienerProcess(0.,0.))

@doc raw"""
    RODESystem(input, output, statefunc, outputfunc, state, t, noise, solver=RODESolver)

Constructs a `RODESystem` with `input` and `output`. `statefunc` is the state function and `outputfunc` is the output function.  The `RODESystem` is represented by the equations,
```math 
    \begin{array}{l}
        dx = f(x, u, t, W)dt \\[0.25]
        y = g(x, u, t)
    \end{array}
```
where ``x`` is the `state`, ``u`` is the value of `input`, ``y`` the value of `output`, ant ``t`` is the time `t`. ``f`` is the `statefunc` and ``g`` is the `outputfunc`. ``W`` is the Wiene process. `noise` is the noise of the system and `solver` is used to solve the above differential equation.

The signature of `statefunc` must be of the form 
```julia
function statefunc(dx, x, u, t, W)
    dx .= ... # Update dx 
end
```
and the signature of `outputfunc` must be of the form 
```julia 
function outputfunc(x, u, t)
    y = ... # Compute y
    return y
end
```

# Example 
```julia
julia> function statefunc(dx, x, u, t, W)
         dx[1] = 2x[1]*sin(W[1] - W[2])
         dx[2] = -2x[2]*cos(W[1] + W[2])
       end
statefunc (generic function with 1 method)

julia> outputfunc(x, u, t) = x
outputfunc (generic function with 1 method)

julia> ds = RODESystem(nothing, Bus(2), statefunc, outputfunc, [1., 1.], 0.);
```
"""
mutable struct RODESystem{IB, OB, T, H, SF, OF, ST, I} <: AbstractRODESystem
    @generic_dynamic_system_fields
    # noise::N
    function RODESystem(input, output, statefunc, outputfunc, state, t, args...; alg=RODEAlg, kwargs...)
        # haskey(solver.params, :dt) || @warn "`solver` must have `:dt` initialized in its `params` for the systems to evolve."
        trigger = Link()
        handshake = Link(Bool)
        integrator = construct_integrator(RODEProblem, input, statefunc, state, t, alg, args...; kwargs...)
        new{typeof(input), typeof(output), typeof(trigger), typeof(handshake), typeof(statefunc), typeof(outputfunc), 
            typeof(state), typeof(integrator)}(input, output, trigger, handshake, Callback[], uuid4(),
            statefunc, outputfunc, state, t, integrator)
    end
end

show(io::IO, ds::RODESystem) = print(io, "RODESystem(state:$(ds.state), t:$(ds.t), input:$(checkandshow(ds.input)), ",  
    "output:$(checkandshow(ds.output)))")


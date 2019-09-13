# This file contains the generic fields of some types in Components module.

import ....JuSDL.Utilities: Callback
import ....JuSDL.Connections: Bus, Link


@def generic_source_fields begin
    outputfunc::OF 
    output::OB
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_static_system_fields begin
    outputfunc::OF 
    input::IB
    output::OB 
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_discrete_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    t::Int
    input::IB 
    output::OB 
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_ode_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    t::Float64
    input::IB 
    output::OB 
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_dae_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    stateder::Vector{Float64}
    t::Float64
    diffvars::D
    input::IB 
    output::OB 
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_rode_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    t::Float64
    input::IB 
    output::OB
    noise::N
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_sde_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    t::Float64
    input::IB 
    output::OB 
    noise::N
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_dde_system_fields begin
    statefunc::SF 
    outputfunc::OF 
    state::Vector{Float64}
    history::H 
    t::Float64
    input::IB 
    output::OB
    solver::S
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

@def generic_sink_fields begin
    input::IB
    databuf::DB
    timebuf::TB
    plugin::P
    trigger::Link{Float64}
    callbacks::Vector{Callback}
    id::UUID
end

# This file includes the Plugins module

@reexport module Plugins

using LibGit2
using Random

abstract type AbstractPlugin end

# Define generic plugin functions.
function process end
function enable end
function disable end
function check end
function add end
function remove end

function search(rootpath::String, filename)
    paths = String[]
    for (root, dirs, files) in walkdir(rootpath)
        for file in files
            if occursin(filename, file)
                push!(paths, joinpath(root, file))
            end
        end
    end
    paths
end

const remote_repo_url = "https://imel.eee.deu.edu.tr/git/JuSDLPlugins.jl.git"

function add(name, url=remote_repo_url)
    startswith(name, ".") && error("Name of plugin should not start with `.`")
    startswith(name, "Plugins") && error("Name of plugin cannot be `Plugins`")
    startswith(".jl", name) || (name *= ".jl")
    
    repopath = joinpath("/tmp", "JuSDLPlugins", randstring())
    ispath(repopath) || mkpath(repopath)
    @info "Cloning avaliable plugins from $url"
    LibGit2.clone(url, repopath)
    @info "Done..."

    @info "Searching for $name in plugins repo."
    srcpath = search(joinpath(repopath, "src"), name)[1]
    if isempty(srcpath)
        error("$name could not be found in avaliable plugins")
    else
        dstdir = joinpath(@__DIR__, "additionals")
        dstpath = joinpath(dstdir, name)
        cp(srcpath, dstpath, force=true)
        include(dstpath)
        @info "$name is added to JuSDL.Plugins"
    end
end

# Includes essential plugins from JuSDL
foreach(include, search(joinpath(@__DIR__, "essentials"), ".jl"))

# Includes additional plugins from JuSDL
foreach(include, search(joinpath(@__DIR__, "additionals"), ".jl"))

# Include plugins from user working directory.
user_plugins_path = joinpath(pwd(), "plugins")
ispath(user_plugins_path) && foreach(include, search(joinpath(user_plugins_path), ".jl"))

end  # module
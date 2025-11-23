using Documenter
using SpringRank

makedocs(;
    modules = [SpringRank],
    format = Documenter.HTML(),
    sitename = "SpringRank.jl",
    source = "src",
    build = "build",
    remotes = nothing,
)

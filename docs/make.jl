import Documenter
push!(LOAD_PATH, "../src")
using SpringRank
Documenter.makedocs(
    modules = [SpringRank],
    sitename = "SpringRank.jl",
    format = Documenter.HTML(),
    checkdocs = :none,
)

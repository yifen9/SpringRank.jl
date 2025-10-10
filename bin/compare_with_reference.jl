#!/usr/bin/env julia
using DelimitedFiles, Statistics, StatsBase

if length(ARGS) < 2
    error("usage: compare_with_reference.jl <julia_out.txt> <reference.dat>")
end

fj = ARGS[1]
fref = ARGS[2]

rj = vec(readdlm(fj))
rj .-= mean(rj)

R = readdlm(fref)
ids = Vector{Int}(R[:,1])
vals = Vector{Float64}(R[:,2])
n = length(rj)
rref = fill(NaN, n)
for k in eachindex(ids)
    i = ids[k]
    if 1 <= i <= n
        rref[i] = vals[k]
    end
end
m = mean(skipmissing(filter(!isnan, rref)))
for i in 1:n
    if isnan(rref[i])
        rref[i] = m
    end
end
rref .-= mean(rref)

ρ = corspearman(rj, rref)
mse = mean((rj .- rref).^2)
println("spearman=", ρ)
println("mse=", mse)
if !(ρ ≥ 0.99 && mse ≤ 1e-6)
    error("mismatch")
end

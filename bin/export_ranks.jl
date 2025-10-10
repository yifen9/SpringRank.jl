#!/usr/bin/env julia
using DelimitedFiles, SparseArrays, Statistics
using SpringRank

if length(ARGS) < 2
    error("usage: export_ranks.jl <adjacency.dat> <out.txt> [lambda] [method] [krylov]")
end

fin = ARGS[1]
fout = ARGS[2]
λ = length(ARGS) >= 3 ? parse(Float64, ARGS[3]) : 1e-8
method = length(ARGS) >= 4 ? Symbol(ARGS[4]) : :auto
krylov = length(ARGS) >= 5 ? Symbol(ARGS[5]) : :gmres

X = readdlm(fin)
I = Vector{Int}(X[:,1])
J = Vector{Int}(X[:,2])
V = Vector{Float64}(X[:,3])
n = maximum(max.(I,J))
A = sparse(I,J,V,n,n)

r = SpringRank.springrank(A; λ=λ, method=method, krylov=krylov)
r .-= mean(r)

open(fout, "w") do io
    for i in 1:length(r)
        println(io, r[i])
    end
end

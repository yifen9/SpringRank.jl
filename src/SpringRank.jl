module SpringRank

using LinearSolve
using IterativeSolvers
using Graphs
using CSV, DataFrames, Tables
using SparseArrays

include("core/model.jl")
include("core/assemble.jl")
include("solvers/direct.jl")
include("solvers/krylov.jl")
include("io/edgelist.jl")
include("io/adjacency.jl")

using .CoreModel
using .CoreAssemble
using .DirectSolve
using .KrylovSolve
using .IOEdgeList
using .IOAdjacency

function springrank(A::SparseMatrixCSC; λ::Real=1e-8, method::Symbol=:auto, tol::Real=1e-6, maxiter::Integer=10000)
    L, b = CoreModel.build_system_from_adjacency(A; λ=λ)
    n = size(A, 1)
    if method == :direct || (method == :auto && n ≤ 2000)
        return DirectSolve.springrank_direct(L, b)
    else
        return KrylovSolve.springrank_krylov(L, b; tol=tol, maxiter=maxiter)
    end
end

function springrank_pairs(pairs; n::Integer, λ::Real=1e-8, method::Symbol=:auto, src::Symbol=:src, dst::Symbol=:dst, w::Symbol=:w, tol::Real=1e-6, maxiter::Integer=10000)
    A = CoreAssemble.assemble_from_edges(pairs; n=n, src=src, dst=dst, w=w)
    return springrank(A; λ=λ, method=method, tol=tol, maxiter=maxiter)
end

export springrank, springrank_pairs

end

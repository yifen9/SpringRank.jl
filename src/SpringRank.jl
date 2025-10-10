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
include("metrics/prediction.jl")
include("metrics/correlation.jl")

using .CoreModel
using .CoreAssemble
using .DirectSolve
using .KrylovSolve
using .IOEdgeList
using .IOAdjacency
using .MetricsPrediction
using .MetricsCorrelation

function springrank(
    A::SparseMatrixCSC;
    λ::Real = 1e-8,
    method::Symbol = :auto,
    reltol::Real = 1e-6,
    abstol::Real = 0.0,
    maxiter::Integer = 10000,
    restart::Integer = 0,
    tol::Union{Nothing,Real} = nothing,
    Pl = nothing,
    Pr = nothing,
)
    L, b = CoreModel.build_system_from_adjacency(A; λ = λ)
    rt = tol === nothing ? reltol : float(tol)
    n = size(A, 1)
    if method == :direct || (method == :auto && n ≤ 2000)
        return DirectSolve.springrank_direct(L, b)
    else
        return KrylovSolve.springrank_krylov(
            L,
            b;
            reltol = rt,
            abstol = abstol,
            maxiter = maxiter,
            restart = restart,
            Pl = Pl,
            Pr = Pr,
        )
    end
end

function springrank(
    g::Graphs.AbstractGraph;
    λ::Real = 1e-8,
    method::Symbol = :auto,
    reltol::Real = 1e-6,
    abstol::Real = 0.0,
    maxiter::Integer = 10000,
    restart::Integer = 0,
    tol::Union{Nothing,Real} = nothing,
)
    A = let w = try
            Graphs.weights(g)
        catch
            nothing
        end
        if w !== nothing && !(w isa Graphs.DefaultDistance)
            if w isa SparseArrays.AbstractSparseMatrixCSC
                w
            elseif w isa AbstractMatrix
                SparseArrays.sparse(w)
            else
                Graphs.adjacency_matrix(g)
            end
        else
            Graphs.adjacency_matrix(g)
        end
    end
    return springrank(
        A;
        λ = λ,
        method = method,
        reltol = reltol,
        abstol = abstol,
        maxiter = maxiter,
        restart = restart,
        tol = tol,
    )
end


function springrank_pairs(
    pairs;
    n::Integer,
    λ::Real = 1e-8,
    method::Symbol = :auto,
    reltol::Real = 1e-6,
    abstol::Real = 0.0,
    maxiter::Integer = 10000,
    restart::Integer = 0,
    tol::Union{Nothing,Real} = nothing,
    src::Symbol = :src,
    dst::Symbol = :dst,
    w::Symbol = :w,
)
    A = CoreAssemble.assemble_from_edges(pairs; n = n, src = src, dst = dst, w = w)
    return springrank(
        A;
        λ = λ,
        method = method,
        reltol = reltol,
        abstol = abstol,
        maxiter = maxiter,
        restart = restart,
        tol = tol,
    )
end

export springrank,
    springrank_pairs,
    predict_direction,
    evaluate_prediction,
    rank_correlation,
    auc_from_scores

end

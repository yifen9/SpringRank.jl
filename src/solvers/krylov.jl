module KrylovSolve

using IterativeSolvers, SparseArrays

function springrank_krylov(L::SparseArrays.SparseMatrixCSC, b::AbstractVector; tol::Real=1e-6, maxiter::Integer=10000)
    x = zeros(eltype(b), size(L, 1))
    gmres!(x, L, b; tol=tol, maxiter=maxiter, log=false)
    μ = sum(x) / length(x)
    return x .- μ
end

end

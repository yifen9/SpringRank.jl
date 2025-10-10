module KrylovSolve

using IterativeSolvers, SparseArrays

function springrank_krylov(
    A::SparseArrays.SparseMatrixCSC,
    b::AbstractVector;
    tol::Real = 1e-6,
    maxiter::Integer = 10_000,
)
    x = zeros(eltype(b), size(A, 1))
    IterativeSolvers.gmres!(x, A, b; tol = tol, maxiter = maxiter, log = false)
    return x
end

end

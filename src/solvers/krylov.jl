module KrylovSolve

using IterativeSolvers, SparseArrays

function springrank_krylov(
    L::SparseArrays.SparseMatrixCSC,
    b::AbstractVector;
    reltol::Real = 1e-6,
    abstol::Real = 0.0,
    maxiter::Integer = 10000,
    restart::Integer = 0,
)
    x = zeros(eltype(b), size(L, 1))
    if restart > 0
        gmres!(
            x,
            L,
            b;
            reltol = reltol,
            abstol = abstol,
            maxiter = maxiter,
            restart = restart,
            log = false,
            initially_zero = true,
            verbose = false,
        )
    else
        gmres!(
            x,
            L,
            b;
            reltol = reltol,
            abstol = abstol,
            maxiter = maxiter,
            log = false,
            initially_zero = true,
            verbose = false,
        )
    end
    μ = sum(x) / length(x)
    return x .- μ
end

end

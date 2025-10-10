module KrylovSolve

using IterativeSolvers, SparseArrays

function springrank_krylov(
    L::SparseArrays.SparseMatrixCSC,
    b::AbstractVector;
    reltol::Real = 1e-6,
    abstol::Real = 0.0,
    maxiter::Integer = 10000,
    restart::Integer = 0,
    Pl = nothing,
    Pr = nothing,
)
    x = zeros(eltype(b), size(L, 1))

    common = (;
        reltol = reltol,
        abstol = abstol,
        maxiter = maxiter,
        log = false,
        initially_zero = true,
        verbose = false,
    )
    with_restart = restart > 0 ? (; restart = restart) : NamedTuple()

    preconds = NamedTuple()
    if Pl !== nothing
        preconds = (; preconds..., Pl = Pl)
    end
    if Pr !== nothing
        preconds = (; preconds..., Pr = Pr)
    end

    kwargs = (; common..., with_restart..., preconds...)

    gmres!(x, L, b; kwargs...)

    μ = sum(x) / length(x)
    return x .- μ
end

end

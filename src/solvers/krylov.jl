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
    krylov::Symbol = :gmres,
)
    x = zeros(eltype(b), size(L, 1))

    if krylov === :gmres
        kwargs = (
            reltol = reltol,
            abstol = abstol,
            maxiter = maxiter,
            log = false,
            initially_zero = true,
            verbose = false,
        )
        kw = Pl === nothing ? kwargs : merge(kwargs, (; Pl = Pl))
        kw = Pr === nothing ? kw : merge(kw, (; Pr = Pr))
        kw = restart > 0 ? merge(kw, (; restart = restart)) : kw
        gmres!(x, L, b; kw...)

    elseif krylov === :cg
        kwargs = (
            reltol = reltol,
            abstol = abstol,
            maxiter = maxiter,
            log = false,
            initially_zero = true,
            verbose = false,
        )
        kw = Pl === nothing ? kwargs : merge(kwargs, (; Pl = Pl))
        kw = Pr === nothing ? kw : merge(kw, (; Pr = Pr))
        cg!(x, L, b; kw...)

    elseif krylov === :bicgstabl
        l = 1
        mv = max(2 * (l + 1) * maxiter, 1)
        kwargs = (
            reltol = reltol,
            abstol = abstol,
            max_mv_products = mv,
            log = false,
            verbose = false,
            initial_zero = true,
        )
        kw = Pl === nothing ? kwargs : merge(kwargs, (; Pl = Pl))
        bicgstabl!(x, L, b, l; kw...)

    else
        error("unsupported krylov method")
    end

    μ = sum(x) / length(x)
    return x .- μ
end

end

using Test, SparseArrays
using SpringRank

@testset "solver-variants-consistency" begin
    n = 300
    I = rand(1:n, 2000)
    J = rand(1:n, 2000)
    V = rand(2000)
    A = sparse(I, J, V, n, n)
    r_dir = SpringRank.springrank(A; method = :direct, λ = 1e-6)
    r_gm = SpringRank.springrank(
        A;
        method = :krylov,
        krylov = :gmres,
        λ = 1e-6,
        reltol = 1e-8,
        maxiter = 20000,
        restart = 100,
    )
    r_bg = SpringRank.springrank(
        A;
        method = :krylov,
        krylov = :bicgstabl,
        λ = 1e-6,
        reltol = 1e-8,
        maxiter = 20000,
    )
    r_cg = SpringRank.springrank(
        A;
        method = :krylov,
        krylov = :cg,
        λ = 1e-6,
        reltol = 1e-8,
        maxiter = 20000,
    )
    @test isapprox(r_dir, r_gm; atol = 1e-6, rtol = 1e-6)
    @test isapprox(r_dir, r_bg; atol = 1e-6, rtol = 1e-6)
    @test isapprox(r_dir, r_cg; atol = 1e-6, rtol = 1e-6)
end

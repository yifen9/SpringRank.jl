using Test, SparseArrays
using SpringRank

@testset "disconnected-graph-regularization" begin
    A = spzeros(5, 5)
    r1 = SpringRank.springrank(A; method = :direct, λ = 1e-6)
    r2 = SpringRank.springrank(
        A;
        method = :krylov,
        λ = 1e-6,
        reltol = 1e-10,
        maxiter = 20000,
    )
    @test isfinite(sum(abs, r1))
    @test isfinite(sum(abs, r2))
    @test isapprox(r1, r2; atol = 1e-8, rtol = 1e-8)
end

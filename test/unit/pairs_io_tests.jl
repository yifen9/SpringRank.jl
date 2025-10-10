using Test, DataFrames
using SpringRank

@testset "pairs-io-end2end" begin
    df = DataFrame(src = [1, 1, 2], dst = [2, 3, 3], w = [1.0, 2.0, 1.0])
    r = SpringRank.springrank_pairs(df; n = 3, method = :direct, λ = 1e-8)
    @test length(r) == 3
    r2 = SpringRank.springrank_pairs(
        df;
        n = 3,
        method = :krylov,
        λ = 1e-8,
        reltol = 1e-8,
        maxiter = 20000,
    )
    @test isapprox(r, r2; rtol = 1e-6, atol = 1e-6)
    A2 = SpringRank.IOAdjacency.to_adjacency(df, :src, :dst, :w, 3)
    rA = SpringRank.springrank(A2; method = :direct, λ = 1e-8)
    rDF = SpringRank.springrank_pairs(df; n = 3, method = :direct, λ = 1e-8)
    @test isapprox(rA, rDF; atol = 1e-8, rtol = 1e-8)
end

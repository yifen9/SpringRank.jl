using Test
using SpringRank

@testset "spearman-rank-correlation" begin
    x = [1.0, 3.0, 2.0, 2.0]
    y = [10.0, 30.0, 20.0, 20.0]
    ρ = SpringRank.rank_correlation(x, y)
    @test isapprox(ρ, 1.0; atol = 1e-12)
end

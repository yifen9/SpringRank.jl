using Test, SparseArrays
using SpringRank

@testset "two-node-analytic" begin
    A = sparse([1], [2], [1.0], 2, 2)
    r = SpringRank.springrank(A; method = :direct, λ = 1e-6)
    @test isapprox(r[1] - r[2], 1.0; atol = 1e-3, rtol = 1e-3)
    @test isapprox(sum(r), 0.0; atol = 1e-8)
end

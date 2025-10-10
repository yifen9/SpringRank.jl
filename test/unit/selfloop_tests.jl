using Test, SparseArrays
using Statistics
using SpringRank

@testset "self-loops-neutral" begin
    n = 3
    A = sparse([1, 1, 2], [2, 1, 3], [1.0, 0.0, 1.0], n, n)
    r = SpringRank.springrank(A; method = :direct, λ = 1e-8)
    A2 = copy(A);
    A2[1, 1] = 5.0
    r2 = SpringRank.springrank(A2; method = :direct, λ = 1e-8)
    @test isapprox(r .- mean(r), r2 .- mean(r2); atol = 1e-8, rtol = 1e-8)
end

using Test, Graphs, SparseArrays
using SpringRank

@testset "graphs-api-consistency" begin
    g = SimpleDiGraph(5)
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 3, 4)
    add_edge!(g, 4, 5)
    r1 = SpringRank.springrank(g; method = :direct, λ = 1e-8)
    A = Graphs.adjacency_matrix(g)
    r2 = SpringRank.springrank(A; method = :direct, λ = 1e-8)
    @test isapprox(r1, r2; atol = 1e-8, rtol = 1e-8)
end

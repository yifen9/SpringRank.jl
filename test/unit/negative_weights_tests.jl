using Test, DataFrames
using SpringRank

@testset "negative-weights-rejected" begin
    df = DataFrame(src = [1], dst = [2], w = [-1.0])
    @test_throws ArgumentError SpringRank.springrank_pairs(df; n = 2, method = :direct)
end

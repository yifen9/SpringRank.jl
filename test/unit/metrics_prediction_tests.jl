using Test, SparseArrays, DataFrames
using SpringRank

@testset "prediction-accuracy-and-auc-consistent" begin
    A = spzeros(5, 5)
    A[1, 2] = 2.0
    A[1, 3] = 1.0
    A[2, 4] = 1.0
    A[3, 4] = 1.0
    A[4, 5] = 1.0
    r = SpringRank.springrank(A; method = :direct, λ = 1e-8)
    df = DataFrame(
        src = [1, 1, 2, 3, 4],
        dst = [2, 3, 4, 4, 5],
        w = [2.0, 1.0, 1.0, 1.0, 1.0],
    )
    res = SpringRank.predict_direction(r, df)
    @test 0.0 ≤ res.acc ≤ 1.0
    auc = SpringRank.auc_from_scores(res.y_true, res.y_score)
    @test 0.0 ≤ auc ≤ 1.0 || isnan(auc)
end

@testset "perfect-separable" begin
    r = [3.0, 2.0, 1.0]
    df = DataFrame(src = [1, 1, 3], dst = [2, 3, 1], w = [1.0, 1.0, -1.0])
    ev = SpringRank.evaluate_prediction(r, df)
    @test ev.acc == 1.0
    @test ev.auc == 1.0
end


@testset "degenerate-class" begin
    r = [0.0, 0.0]
    df = DataFrame(src = [1, 1], dst = [2, 2], w = [1.0, 1.0])
    ev = SpringRank.evaluate_prediction(r, df)
    @test 0.0 ≤ ev.acc ≤ 1.0
    @test isnan(ev.auc)
end

using Test, DataFrames
using SpringRank

@testset "proba-monotone-auc-invariant" begin
    r = [3.0, 2.0, 1.0]
    df = DataFrame(src = [1, 1, 3, 2], dst = [2, 3, 1, 3], w = [1.0, 1.0, -1.0, -1.0])
    ev1 = SpringRank.evaluate_prediction(r, df)
    pr = SpringRank.predict_proba(r, df; β = 2.0)
    auc = SpringRank.auc_from_scores(pr.y_true, pr.y_score)
    @test isapprox(ev1.auc, auc; atol = 0, rtol = 0)
end

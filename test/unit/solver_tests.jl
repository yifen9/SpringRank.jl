using Test, SparseArrays
using SpringRank

@testset "solver-consistency" begin
    n = 100
    I = rand(1:n, 400)
    J = rand(1:n, 400)
    V = rand(400)
    A = sparse(I, J, V, n, n)
    r1 = SpringRank.springrank(A; method = :direct, λ = 1e-8)
    r2 = SpringRank.springrank(A; method = :krylov, λ = 1e-8, tol = 1e-8, maxiter = 10000)
    @test isapprox(r1, r2; rtol = 1e-6, atol = 1e-6)
    @test abs(sum(r1)) ≤ 1e-8
    @test abs(sum(r2)) ≤ 1e-8
end

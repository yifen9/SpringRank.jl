using Test, SparseArrays
using SpringRank

@testset "krylov-plpr-passthrough" begin
    n = 50
    I = rand(1:n, 200)
    J = rand(1:n, 200)
    V = rand(200)
    A = sparse(I, J, V, n, n)
    r = SpringRank.springrank(
        A;
        method = :krylov,
        λ = 1e-6,
        reltol = 1e-8,
        maxiter = 5000,
        Pl = nothing,
        Pr = nothing,
    )
    @test length(r) == n
end

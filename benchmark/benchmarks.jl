using PkgBenchmark
using BenchmarkTools
using SpringRank
using SparseArrays, Random

SUITE = BenchmarkGroup()

SUITE["random-sparse-small"] = @benchmarkable SpringRank.springrank(A; λ = 1e-8) setup=(
    begin
        Random.seed!(1234)
        n = 200
        I = rand(1:n, 800)
        J = rand(1:n, 800)
        V = rand(800)
        A = sparse(I, J, V, n, n)
    end
)

SUITE["random-sparse-large-krylov"] = @benchmarkable SpringRank.springrank(
    A;
    λ = 1e-8,
    method = :krylov,
    krylov = :gmres,
    reltol = 1e-6,
) setup=(
    begin
        Random.seed!(1234)
        n = 2000
        I = rand(1:n, 8000)
        J = rand(1:n, 8000)
        V = rand(8000)
        A = sparse(I, J, V, n, n)
    end
)

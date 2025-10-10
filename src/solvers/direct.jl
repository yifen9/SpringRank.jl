module DirectSolve

using LinearSolve, SparseArrays

function springrank_direct(L::SparseArrays.SparseMatrixCSC, b::AbstractVector)
    prob = LinearProblem(L, b)
    sol = solve(prob)
    x = sol.u
    μ = sum(x) / length(x)
    return x .- μ
end

end

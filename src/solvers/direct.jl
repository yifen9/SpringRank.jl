module DirectSolve

using LinearSolve, SparseArrays

function springrank_direct(A::SparseArrays.SparseMatrixCSC, b::AbstractVector; kwargs...)
    prob = LinearProblem(A, b)
    sol = solve(prob)
    return sol.u
end

end

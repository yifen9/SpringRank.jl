module DirectSolve

using SparseArrays, LinearAlgebra

function springrank_direct(L::SparseArrays.SparseMatrixCSC, b::AbstractVector)
    x = L \ b
    μ = sum(x) / length(x)
    return x .- μ
end

end

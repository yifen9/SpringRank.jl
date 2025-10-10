module CoreModel

using SparseArrays

function build_system_from_adjacency(A::SparseArrays.SparseMatrixCSC; λ::Real = 0.0)
    return A, λ
end

function build_system_from_pairs(pairs; n::Integer, λ::Real = 0.0)
    return pairs, n, λ
end

end

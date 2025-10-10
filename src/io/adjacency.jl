module IOAdjacency

using SparseArrays

function to_adjacency(df, src::Symbol, dst::Symbol, w::Symbol, n::Integer)
    I = Int[]
    J = Int[]
    V = Float64[]
    return sparse(I, J, V, n, n)
end

end

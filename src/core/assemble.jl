module CoreAssemble

using SparseArrays

function assemble_from_edges(edges::AbstractVector{<:Tuple}; n::Integer)
    I = Int[]
    J = Int[]
    V = Float64[]
    return sparse(I, J, V, n, n)
end

end

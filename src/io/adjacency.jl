module IOAdjacency

using SparseArrays, Tables

function to_adjacency(df, src::Symbol, dst::Symbol, w::Symbol, n::Integer)
    I = Int[]
    J = Int[]
    V = Float64[]
    for row in Tables.rows(df)
        push!(I, Int(getfield(row, src)))
        push!(J, Int(getfield(row, dst)))
        push!(V, Float64(getfield(row, w)))
    end
    return sparse(I, J, V, n, n)
end

end

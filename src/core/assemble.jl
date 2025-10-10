module CoreAssemble

using SparseArrays
using Tables

function assemble_from_edges(pairs; n::Integer, src::Symbol=:src, dst::Symbol=:dst, w::Symbol=:w)
    I = Int[]
    J = Int[]
    V = Float64[]
    for row in Tables.rows(pairs)
        i = Int(getfield(row, src))
        j = Int(getfield(row, dst))
        wij = Float64(getfield(row, w))
        push!(I, i); push!(J, j); push!(V, wij)
    end
    return sparse(I, J, V, n, n)
end

end

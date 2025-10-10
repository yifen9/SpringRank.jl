module CoreAssemble

using SparseArrays
using Tables

function assemble_from_edges(
    pairs;
    n::Integer,
    src::Symbol = :src,
    dst::Symbol = :dst,
    w::Symbol = :w,
)
    I = Int[]
    J = Int[]
    V = Float64[]
    for row in Tables.rows(pairs)
        i = Int(getproperty(row, src))
        j = Int(getproperty(row, dst))
        wij = Float64(getproperty(row, w))
        if !(wij ≥ 0)
            throw(ArgumentError("negative weight"))
        end
        push!(I, i);
        push!(J, j);
        push!(V, wij)
    end
    return sparse(I, J, V, n, n)
end

end

module IOEdgeList

using CSV, DataFrames, Tables

function read_edgelist(
    path::AbstractString;
    src::Symbol = :src,
    dst::Symbol = :dst,
    w::Symbol = :w,
)
    df = DataFrames.DataFrame(CSV.File(path))
    return df, src, dst, w
end

end

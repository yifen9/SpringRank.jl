module IOEdgeList

using CSV, DataFrames

function read_edgelist(path::AbstractString; src::Symbol=:src, dst::Symbol=:dst, w::Symbol=:w)
    df = DataFrame(CSV.File(path))
    return df, src, dst, w
end

end

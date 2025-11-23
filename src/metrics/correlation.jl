module MetricsCorrelation

using Statistics

function _tied_ranks(x::AbstractVector{<:Real})
    n = length(x)
    ord = sortperm(x, alg = QuickSort)
    r = similar(x, Float64, n)
    i = 1
    while i <= n
        j = i
        v = x[ord[i]]
        while j <= n && x[ord[j]] == v
            j += 1
        end
        avg = (i + j - 1) / 2
        for k = i:(j-1)
            r[ord[k]] = avg
        end
        i = j
    end
    return r
end

"""
    rank_correlation(r, rref; method=:spearman)

Compute Spearman rank correlation between `r` and reference scores `rref`.
"""
function rank_correlation(
    r::AbstractVector,
    rref::AbstractVector;
    method::Symbol = :spearman,
)
    if method == :spearman
        ρ = cor(_tied_ranks(r), _tied_ranks(rref))
        return ρ
    else
        throw(ArgumentError("unsupported method"))
    end
end

export rank_correlation

end

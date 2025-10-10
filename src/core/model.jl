module CoreModel

using SparseArrays, LinearAlgebra

function build_system_from_adjacency(A::SparseArrays.SparseMatrixCSC; λ::Real = 0.0)
    n = size(A, 1)
    dout = vec(sum(A, dims = 2))
    din = vec(sum(A, dims = 1))
    D = spdiagm(0 => dout .+ din)
    L = D - (A + transpose(A))
    if λ != 0
        L = L + spdiagm(0 => fill(float(λ), n))
    end
    b = dout .- din
    return L, b
end

function build_system_from_pairs(
    pairs;
    n::Integer,
    λ::Real = 0.0,
    src::Symbol = :src,
    dst::Symbol = :dst,
    w::Symbol = :w,
    assemble,
)
    A = assemble(pairs; n = n, src = src, dst = dst, w = w)
    return build_system_from_adjacency(A; λ = λ)
end

end

module CoreModel

using SparseArrays, LinearAlgebra

function build_system_from_adjacency(A::SparseArrays.SparseMatrixCSC; λ::Real = 0.0)
    n = size(A, 1)
    AT = SparseArrays.SparseMatrixCSC{Float64,Int}(A)
    dout = Float64.(vec(sum(AT, dims = 2)))
    din = Float64.(vec(sum(AT, dims = 1)))
    D = spdiagm(0 => dout .+ din)
    L = D - (AT + transpose(AT))
    if λ != 0
        L = L + spdiagm(0 => fill(Float64(λ), n))
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

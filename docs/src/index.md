# SpringRank.jl

SpringRank.jl implements the SpringRank algorithm for ranking nodes in directed networks.

## Basic usage

```julia
using SpringRank, SparseArrays

A = sparse([1, 1, 2], [2, 3, 3], [1.0, 2.0, 1.0], 3, 3)
r = springrank(A)
```

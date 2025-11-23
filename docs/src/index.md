# SpringRank.jl

SpringRank.jl implements the SpringRank algorithm for ranking nodes in directed networks.

## Basic usage

```julia
using SpringRank, SparseArrays

A = sparse([1, 1, 2], [2, 3, 3], [1.0, 2.0, 1.0], 3, 3)
r = springrank(A)
```

## API

```@docs
springrank
springrank_pairs
rank_correlation
predict_direction
evaluate_prediction
auc_from_scores
predict_proba
```

## Auto Docs

```@autodocs
Modules = [SpringRank]
Order   = [:function, :type]
```
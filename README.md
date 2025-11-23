[![Compat Helper](https://github.com/yifen9/SpringRank.jl/actions/workflows/compat-helper.yaml/badge.svg)](https://github.com/yifen9/SpringRank.jl/actions/workflows/compat-helper.yaml) [![CI](https://github.com/yifen9/SpringRank.jl/actions/workflows/ci.yaml/badge.svg)](https://github.com/yifen9/SpringRank.jl/actions/workflows/ci.yaml) [![Docs](https://github.com/yifen9/SpringRank.jl/actions/workflows/docs.yaml/badge.svg)](https://github.com/yifen9/SpringRank.jl/actions/workflows/docs.yaml) [![Image](https://github.com/yifen9/SpringRank.jl/actions/workflows/image.yaml/badge.svg)](https://github.com/yifen9/SpringRank.jl/actions/workflows/image.yaml)

# SpringRank.jl

SpringRank.jl implements the [SpringRank](https://arxiv.org/abs/1709.09002) algorithm for ranking nodes in directed networks, with a focus on:

- Sparse linear algebra (iterative and direct solvers)
- Multiple input formats (sparse matrices, Graphs.jl graphs, Tables.jl-compatible edge lists)
- Simple evaluation metrics for link prediction and ranking quality

## Installation

SpringRank.jl is currently under development.

For now you can develop it locally:

```julia
using Pkg
Pkg.develop(url = "https://github.com/yifen9/SpringRank.jl")
```

After it is registered in the General registry, it will be installable with:

```julia
] add SpringRank
```

## Basic usage

### Sparse adjacency matrix

```julia
using SpringRank, SparseArrays

A = sparse([1, 1, 2], [2, 3, 3], [1.0, 2.0, 1.0], 3, 3)
r = springrank(A)
```

`r` is a vector of SpringRank scores, normalized to have zero mean.

You can control the solver and regularization:

```julia
r = springrank(A; λ = 1e-8, method = :auto)      # automatic direct / Krylov
r = springrank(A; λ = 1e-6, method = :direct)    # direct solver
r = springrank(A; λ = 1e-6, method = :krylov)    # iterative solver
```

### Graphs.jl integration

Any `Graphs.AbstractGraph` is supported via its adjacency matrix:

```julia
using SpringRank, Graphs

g = SimpleDiGraph(5)
add_edge!(g, 1, 2); add_edge!(g, 1, 3)
add_edge!(g, 2, 4); add_edge!(g, 3, 4)
add_edge!(g, 4, 5)

r = springrank(g)
```

If the graph has weights, SpringRank uses them when possible.

### Edge lists via Tables.jl (e.g. DataFrames)

SpringRank can assemble the adjacency matrix from any Tables.jl-compatible source, such as a `DataFrame` of edges:

```julia
using SpringRank, DataFrames

edges = DataFrame(
    src = [1, 1, 2],
    dst = [2, 3, 3],
    w   = [1.0, 2.0, 1.0],
)

r = springrank_pairs(edges; n = 3)
```

The column names can be customized via keywords (`src`, `dst`, `w`).

## Evaluation metrics

SpringRank.jl provides some basic utilities for link prediction evaluation.

Given scores `r` and an edge list, you can evaluate prediction accuracy and AUC:

```julia
using SpringRank, DataFrames

edges = DataFrame(
    src = [1, 1, 2, 3],
    dst = [2, 3, 3, 1],
    w   = [1.0, 1.0, 1.0, -1.0],
)

# Accuracy and AUC
ev = evaluate_prediction(r, edges)
ev.acc    # accuracy
ev.auc    # AUC

# Probability-style scores
pr = predict_proba(r, edges; β = 1.0)
pr.proba      # predicted probabilities
pr.y_true     # binary labels
pr.y_score    # raw scores
```

You can also compute rank correlation with a reference ranking:

```julia
using SpringRank

ρ = rank_correlation(r, r_ref)  # Spearman correlation
```

## Development

This repository uses `just` to drive common tasks.

- Run tests:

```bash
just test
```

- Quality checks (Aqua, JET) and formatting:

```bash
just fmt
just qa-aqua
just qa-jet
```

- Benchmarks:

```bash
just bench
```

- Build local documentation (Documenter.jl):

```bash
just docs
```

- CI entry point (used by GitHub Actions):

```bash
just ci
```

## License

SpringRank.jl is released under the MIT License. See `LICENSE` for details.

# Data

This directory contains sample data used for testing and benchmarks of SpringRank.jl.

## Files

- `US_CS_adjacency.dat`  
  Weighted directed edges between North American computer science departments.
  An entry `i j w` indicates that `w` faculty members with a PhD from institution `i`
  were hired at institution `j`.

- `US_CS_nodes.dat`  
  Mapping from integer node IDs to institution names.

- `US_CS_SpringRank_a0.0_l0_1.0_l1_1.0.dat`  
  Reference SpringRank scores for the same network, for parameters
  α = 0 and ℓ₀ = ℓ₁ = 1.

## Source

These files are taken from the SpringRank reference implementation by
Carlo De Bacco et al.:

- GitHub repository: https://github.com/cdebacco/SpringRank  
- Original dataset and description: https://tuvalu.santafe.edu/~aaronc/facultyhiring/

Please refer to the upstream repository and website for the original data,
attribution, and any licensing or usage terms.

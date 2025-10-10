up:
	julia -e 'using Pkg; Pkg.update()'

add NAME:
	julia -e 'using Pkg; Pkg.add("{{NAME}}")'

rm NAME:
	julia -e 'using Pkg; Pkg.rm("{{NAME}}")'

init:
	julia -e 'using Pkg; Pkg.instantiate()'

resolve:
	julia -e 'using Pkg; Pkg.resolve()'

test:
	julia -e 'using Pkg; Pkg.test()'

fmt:
	julia -e 'using JuliaFormatter; format(".")'

docs:
	julia -e 'using Pkg; Pkg.instantiate(); include("docs/make.jl")'

bench:
	julia -e 'using Pkg; Pkg.activate("."); using PkgBenchmark; benchmarkpkg(".")'

qa-aqua:
	julia -e 'using Pkg; Pkg.activate("."); using Aqua, SpringRank; Aqua.test_all(SpringRank)'

qa-jet:
	julia -e 'using Pkg; Pkg.activate("."); using JET; JET.test_package("SpringRank")'

ci:
	julia -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
	just data-run
	just data-compare

dev:
	just init && just fmt && just test

data-run file="data/US_CS_adjacency.dat" out="artifacts/us_cs_julia.txt" lambda="1e-8" method="krylov" krylov="cg":
	mkdir -p artifacts
	julia --project bin/export_ranks.jl {{file}} {{out}} {{lambda}} {{method}} {{krylov}}

data-compare j_out="artifacts/us_cs_julia.txt" ref="data/US_CS_SpringRank_a0.0_l0_1.0_l1_1.0.dat":
	julia --project bin/compare_with_reference.jl {{j_out}} {{ref}}

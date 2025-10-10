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

dev:
	just init && just test && just fmt && just bench
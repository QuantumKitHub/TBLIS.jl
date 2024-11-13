# TBLIS.jl

[![CI][ci-img]][ci-url]  [![][codecov-img]][codecov-url]

[ci-img]: https://github.com/QuantumKitHub/TBLIS.jl/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/QuantumKitHub/TBLIS.jl/actions/workflows/ci.yml

[codecov-img]: https://codecov.io/gh/QuantumKitHub/TBLIS.jl/graph/badge.svg?token=Nlju9D2P1A
[codecov-url]: https://codecov.io/gh/QuantumKitHub/TBLIS.jl

Julia wrapper for the [TBLIS](https://github.com/devinamatthews/tblis) tensor contraction library.
This provides basic bindings for the functions defined in TBLIS.
The target audience is mostly package developers rather than users, as the interface is low-level
and does not include argument checking.

For users, it is recommended to try out:
- [TensorOperations.jl](https://github.com/Jutho/TensorOperations.jl)
- [ITensors.jl](https://github.com/ITensor/ITensors.jl)

## Acknowledgements

This package is the continuation of a package previously hosted by https://github.com/FermiQC/TBLIS.jl.
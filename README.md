# TBLIS.jl

[![CI][ci-img]][ci-url] [![Coverage][codecov-img]][codecov-url] [![Aqua QA][aqua-img]][aqua-url] [![Code Style: YAS][style-img]][style-url]

[ci-img]: https://github.com/QuantumKitHub/TBLIS.jl/actions/workflows/CI.yml/badge.svg
[ci-url]: https://github.com/QuantumKitHub/TBLIS.jl/actions/workflows/CI.yml

[codecov-img]: https://codecov.io/gh/QuantumKitHub/TBLIS.jl/graph/badge.svg?token=Nlju9D2P1A
[codecov-url]: https://codecov.io/gh/QuantumKitHub/TBLIS.jl

[aqua-img]: https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg
[aqua-url]: https://github.com/JuliaTesting/Aqua.jl

[style-img]: https://img.shields.io/badge/code%20style-yas-blue.svg
[style-url]: https://github.com/jrevels/YASGuide

Julia wrapper for the [TBLIS](https://github.com/devinamatthews/tblis) tensor contraction
library, which implements tensor addition, contraction and reduction directly on strided
memory, without the transpositions and temporaries that a BLAS-based approach requires.

The target audience is mostly package developers rather than users, as the interface is
low-level and does not include argument checking.

For users, it is recommended to try out:
- [TensorOperations.jl](https://github.com/Jutho/TensorOperations.jl)
- [ITensors.jl](https://github.com/ITensor/ITensors.jl)

## Installation

TBLIS.jl is a registered package, so it can be installed through the general registry:

```julia
pkg> add TBLIS
```

The TBLIS library itself is supplied by
[tblis_jll](https://github.com/JuliaBinaryWrappers/tblis_jll.jl), so no manual build step is
required. Only the platforms for which `tblis_jll` ships a binary are supported -- currently
`x86_64` Linux (glibc and musl), macOS, FreeBSD and Windows -- and loading TBLIS.jl anywhere
else errors out with an unsupported-platform message.

## Usage

Three operations are exported, each taking `StridedArray`s along with a string of index
labels per array. Labels follow the spirit of Einstein summation: one character per
dimension, repeated labels are contracted, and the labels of the output determine its
permutation.

```julia
using TBLIS

A = randn(4, 5, 6)
B = randn(6, 7)
C = zeros(4, 5, 7)

# C[i,j,l] := 1.0 * A[i,j,k] * B[k,l] + 0.0 * C[i,j,l]
tblis_tensor_mult(1.0, A, "ijk", B, "kl", 0.0, C, "ijl")

# D[j,i] := 2.0 * A[i,j,j] + 1.0 * D[j,i], tracing over the repeated label
D = zeros(5, 4)
tblis_tensor_add(2.0, view(A, :, :, 1:5), "ijj", 1.0, D, "ji")

# full contraction down to a scalar (note that A is not conjugated)
s = tblis_tensor_dot(1.0, A, "ijk", A, "ijk")
```

| Operation | Semantics |
| :--- | :--- |
| `tblis_tensor_add(α, A, idxA, β, B, idxB)` | ``B[idxB] := β B[idxB] + α A[idxA]``, returns `B` |
| `tblis_tensor_mult(α, A, idxA, B, idxB, β, C, idxC)` | ``C[idxC] := β C[idxC] + α A[idxA] B[idxB]``, returns `C` |
| `tblis_tensor_dot(α, A, idxA, B, idxB)` | ``α A[idxA] B[idxB]`` contracted over all indices, returns a scalar |

Supported element types are `Float32`, `Float64`, `ComplexF32` and `ComplexF64`, and all
arrays in a single call must share their element type -- anything else throws an
`ArgumentError`. These methods keep the arrays and their length and stride buffers alive for
the duration of the call, so they are safe to use directly.

> [!IMPORTANT]
> Conjugation is not supported for `tblis_tensor_mult`. The `tblis_tensor` struct carries a
> `conj` flag, and the underlying library honours it for addition and for dot products, but
> for multiplication it is **silently ignored**: the contraction is carried out with the
> un-conjugated operands and no error is raised. Complex conjugation of an input to a
> contraction therefore has to be applied beforehand, e.g. by contracting with a
> `conj(A)` copy.

The number of threads TBLIS uses can be queried and set at runtime:

```julia
julia> TBLIS.get_num_threads()
8

julia> TBLIS.set_num_threads(4)
```

## Lower-level access

`tblis_scalar` and `tblis_tensor` wrap a `Number` and a `StridedArray` in the corresponding
TBLIS structs, for use with the raw bindings. The full set of auto-generated bindings lives
in `src/lib` and is not exported, but is available as `TBLIS.<name>` for anything the
operations above do not cover. These are regenerated from the TBLIS headers with
[Clang.jl](https://github.com/JuliaInterop/Clang.jl) via `gen/generator.jl`.

> [!WARNING]
> A `tblis_tensor` only stores raw pointers into the array it views, along with the buffers
> holding its lengths and strides. Keeping all three alive -- e.g. with `GC.@preserve` -- for
> as long as TBLIS may access them is the caller's responsibility.

## Acknowledgements

This package is the continuation of a package previously hosted at
[FermiQC/TBLIS.jl](https://github.com/FermiQC/TBLIS.jl).

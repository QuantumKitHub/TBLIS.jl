# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/QuantumKitHub/TBLIS.jl/compare/v0.3.0...HEAD)

### Added

### Changed

### Deprecated

### Removed

### Fixed

## [0.3.0](https://github.com/QuantumKitHub/TBLIS.jl/compare/v0.2.0...v0.3.0) - 2026-08-03

A complete rewrite of the package. The `dlopen`/`dlsym`-based wrapper around a hand-written
`TTensor` type is gone, replaced by auto-generated bindings against the TBLIS headers and a
small set of operations that take strided arrays directly and are GC-safe by construction.
This release is **breaking**: no part of the v0.2 API survives.

This is also the first release from
[QuantumKitHub/TBLIS.jl](https://github.com/QuantumKitHub/TBLIS.jl), continuing the package
previously hosted at [FermiQC/TBLIS.jl](https://github.com/FermiQC/TBLIS.jl).

### Added

- `ComplexF32` and `ComplexF64` element types, alongside `Float32` and `Float64` ([#17]).
- `tblis_tensor_dot(α, A, idxA, B, idxB)`, contracting over all indices and returning a
  scalar ([#26]).
- `tblis_scalar(s)` and `tblis_tensor(A, s, szA, strA)` as thin constructors over the
  generated structs, for use with the raw bindings ([#17], [#26]).
- Mixed or unsupported element types now throw an `ArgumentError`, instead of falling through
  to the low-level bindings and failing obscurely ([#26]).
- Auto-generated bindings for the full TBLIS C API in `src/lib`, available as `TBLIS.<name>`,
  together with a `gen/` regeneration harness built on
  [Clang.jl](https://github.com/JuliaInterop/Clang.jl), pinning the tool versions the
  bindings were generated with ([#17], [#27]).
- Loading the package on a platform `tblis_jll` ships no binary for now errors with an
  explicit unsupported-platform message ([#17], [#27]).
- Test suite covering add / mult / dot against reference implementations, an element-type
  mismatch testset, and Aqua.jl quality checks ([#17], [#26]).

### Changed

- **Breaking:** the operations take `StridedArray`s plus a string of index labels per array,
  and build the TBLIS C structs internally inside a `GC.@preserve` region spanning the
  `ccall` ([#26]):

  ```julia
  tblis_tensor_add(α, A, idxA, β, B, idxB)                  # B[idxB] := β B[idxB] + α A[idxA]
  tblis_tensor_mult(α, A, idxA, B, idxB, β, C, idxC)        # C[idxC] := β C[idxC] + α A[idxA] B[idxB]
  tblis_tensor_dot(α, A, idxA, B, idxB)                     # α A[idxA] B[idxB], fully contracted
  ```

- **Breaking:** exports changed from `TTensor`, `mul!`, `add!` to `tblis_tensor`,
  `tblis_scalar`, `tblis_tensor_add`, `tblis_tensor_mult`, `tblis_tensor_dot` ([#17], [#26]).
- **Breaking:** scaling factors are explicit arguments of every operation rather than baked
  into a tensor wrapper at construction. `mult` and `dot` take a single `α` on the inputs,
  since only the product of two input scalings is observable ([#26]).
- **Breaking:** `TBLIS.set_num_threads(n)` no longer returns the previous thread count.
  Both it and `TBLIS.get_num_threads()` now call the generated bindings directly instead of
  resolving symbols with `dlsym` ([#17]).
- **Breaking:** minimum Julia version raised to 1.10 (was 1.0) ([#17]).
- **Breaking:** supported platforms are restricted to those `tblis_jll` actually ships
  binaries for — `x86_64` Linux (glibc and musl), macOS, FreeBSD and Windows ([#27]).
- `tblis_jll` compat widened to `1.2, 1.3`. The C API is byte-identical between tblis 1.2.0
  and 1.3.0 — only `tblis_config.h` differs — so no wrapper logic changed. 1.2 is kept in the
  range because Pkg's resolver ignores artifact platform availability, which would otherwise
  leave musl users resolving to a 1.3.0 artifact that does not exist for them ([#27]).

### Removed

- **Breaking:** the `TTensor` type and the `mul!` / `add!` methods ([#17]).
- **Breaking:** the `Libdl`, `LinearAlgebra`, `Hwloc_jll` and `Test` dependencies;
  `tblis_jll` is now the only dependency ([#17]).
- The `libtblis.dylib` and `libtci.dylib` binaries previously committed to `src/`; the
  library always comes from `tblis_jll` ([#17]).
- Nine `src/lib` platform files for triples `tblis_jll` has never shipped (aarch64, i686,
  armv7l, powerpc64le) ([#27]).

### Fixed

- `tblis_tensor` built its length and stride buffers as default arguments and returned a
  struct pointing at them with no live reference, so the next garbage collection freed memory
  that TBLIS then dereferenced — a reliable segfault in `tblis_tensor_mult`. The operations
  now keep the arrays and their length/stride buffers alive for the duration of the `ccall`,
  making the failure mode structurally impossible rather than merely documented ([#26]).
- `tblis_tensor_dot` passed its result scalar by copy, so TBLIS wrote into a temporary that
  was immediately discarded and the result was unreachable ([#26]).
- macOS CI had been failing since `setup-julia` was bumped to v3, which hard-errors on
  `arch: x64` for arm64 runners; jobs moved to `macos-15-intel`, the last x86_64 image ([#27]).
- `codecov-action` was warning about the input renamed from `file` to `files` in v5, and
  silently falling back to searching for coverage files ([#27]).
- `FormatCheck` only triggered on `master` while the default branch is `main`, so it never
  ran — and it discarded the result of `format(".")`, so it could not have failed if it had
  ([#27]).

### Migration from v0.2

Wrap-then-operate is replaced by a single call per operation:

```julia
# v0.2
using TBLIS
tA, tB, tC = TTensor(A), TTensor(B), TTensor(C)
mul!(tC, tA, tB, "ijk", "kl", "ijl")

# v0.3
using TBLIS
tblis_tensor_mult(1.0, A, "ijk", B, "kl", 0.0, C, "ijl")
```

### Known limitations

- Conjugation is **silently ignored** by `tblis_tensor_mult`. The `tblis_tensor` struct
  carries a `conj` flag and the library honours it for addition and dot products, but not for
  multiplication, where no error is raised either. Conjugate inputs to a contraction have to
  be materialised beforehand, e.g. by contracting against a `conj(A)` copy.

## [0.2.0](https://github.com/QuantumKitHub/TBLIS.jl/releases/tag/v0.2.0)

Last release from [FermiQC/TBLIS.jl](https://github.com/FermiQC/TBLIS.jl), predating this
changelog.

<!-- Pull request links -->

[#17]: https://github.com/QuantumKitHub/TBLIS.jl/pull/17
[#26]: https://github.com/QuantumKitHub/TBLIS.jl/pull/26
[#27]: https://github.com/QuantumKitHub/TBLIS.jl/pull/27

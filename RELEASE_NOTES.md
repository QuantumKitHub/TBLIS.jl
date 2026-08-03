<!--
Announcement text for the release currently being prepared. Copy the body below verbatim
into the GitHub release and into the `@JuliaRegistrator register` comment, then rewrite this
file for the next release. The full, durable record of changes lives in CHANGELOG.md.
-->

## TBLIS.jl v0.3.0

A complete rewrite: the `dlopen`/`dlsym` wrapper around a hand-written `TTensor` type is
replaced by auto-generated bindings against the TBLIS headers and a small set of operations
that take strided arrays directly and are GC-safe by construction. This release is
**breaking** — no part of the v0.2 API survives.

### Highlights

- **New operation-level API.** `tblis_tensor_add`, `tblis_tensor_mult` and `tblis_tensor_dot`
  take `StridedArray`s plus a string of index labels per array, and build the TBLIS C structs
  internally inside a `GC.@preserve` region spanning the `ccall`. The previous API baked
  pointers to length/stride buffers into a struct with nothing keeping them alive, which
  segfaulted as soon as the garbage collector ran; that failure mode is now structurally
  impossible rather than merely documented.
- **Complex element types.** `ComplexF32` and `ComplexF64` join `Float32` and `Float64`, and
  mixed or unsupported element types throw an `ArgumentError` instead of failing obscurely.
- **Generated bindings.** The full TBLIS C API is available as `TBLIS.<name>` from `src/lib`,
  regenerated from the tblis 1.3.0 headers with Clang.jl via `gen/generator.jl`. The
  `libtblis.dylib`/`libtci.dylib` blobs previously committed to `src/` are gone — the library
  always comes from `tblis_jll`.
- **Breaking:** `TTensor`, `mul!` and `add!` are removed, `set_num_threads` no longer returns
  the previous thread count, the minimum Julia version is now 1.10, and supported platforms
  are restricted to those `tblis_jll` ships binaries for (`x86_64` Linux, macOS, FreeBSD,
  Windows).

Migration examples and the one known limitation (conjugation is silently ignored by
`tblis_tensor_mult`) are documented in the changelog.

### Full Changelog

See [CHANGELOG.md](https://github.com/QuantumKitHub/TBLIS.jl/blob/main/CHANGELOG.md#030---2026-08-03)
for the complete list of changes, or
[v0.2.0...v0.3.0](https://github.com/QuantumKitHub/TBLIS.jl/compare/v0.2.0...v0.3.0) for the
raw diff.

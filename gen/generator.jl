using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()
using Pkg.Artifacts
using Clang.Generators
using Clang.Generators.JLLEnvs
using tblis_jll
using JuliaFormatter

cd(@__DIR__)

# ensure output path exists
outpath = joinpath(@__DIR__, "..", "src", "lib")
!isdir(outpath) && mkpath(outpath)

# headers
include_dir = normpath(joinpath(tblis_jll.artifact_dir, "include"))

tci_h = joinpath(include_dir, "tci.h")
@assert isfile(tci_h)
tblis_h = joinpath(include_dir, "tblis", "tblis.h")
@assert isfile(tblis_h)

# load common option
options = load_options(joinpath(@__DIR__, "generator.toml"))

# the platforms tblis_jll actually ships binaries for
# (x86_64-linux-musl is only available up to tblis_jll 1.2)
const TARGETS = ["x86_64-apple-darwin14",
                 "x86_64-linux-gnu",
                 "x86_64-linux-musl",
                 "x86_64-unknown-freebsd13.2",
                 "x86_64-w64-mingw32"]

# run generator for all supported platforms
for target in TARGETS
    @assert target in JLLEnvs.JLL_ENV_TRIPLES "unknown target triple $target"
    @info "processing $target"
    options["general"]["output_file_path"] = joinpath(outpath, "$target.jl")
    path = options["general"]["output_file_path"]
    args = get_default_args(target)
    push!(args, "-I$include_dir")
    header_files = [tci_h, tblis_h]
    ctx = create_context(header_files, args, options)
    build!(ctx)
    format_file(path, YASStyle())
end

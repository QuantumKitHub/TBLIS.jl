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

# run generator for all platforms
for target in JLLEnvs.JLL_ENV_TRIPLES
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

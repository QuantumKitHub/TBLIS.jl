using SafeTestsets

@time @safetestset "operations" begin
    include("operations.jl")
end

@time @safetestset "Aqua" begin
    include("aqua.jl")
end
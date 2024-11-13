@eval module $(gensym("operations"))

using TBLIS
using Test
using Random

const eltypes = (Float32, Float64, ComplexF32, ComplexF64)

@testset "num_threads" begin
    num_threads = @inferred TBLIS.get_num_threads()

    TBLIS.set_num_threads(2)
    @test TBLIS.get_num_threads() == 2

    TBLIS.set_num_threads(4)
    @test TBLIS.get_num_threads() == 4

    TBLIS.set_num_threads(num_threads)
end

@testset "tblis_tensor_add (ndims=$N, eltype=$T)" for T in eltypes, N in 2:5
    for _ in 1:5 # repeat tests
        szA = rand(1:4, N)
        perm = randperm(length(szA))

        idxA = string(('a' .+ (0:(N - 1)))...)
        idxB = idxA[perm]

        A = rand(T, szA...)
        B = rand!(permutedims(A, perm))
        α = rand(T)
        β = rand(T)

        expected = β * B + α * permutedims(A, perm)

        # actual computation stores result in B
        Atblis = @inferred tblis_tensor(A, α)
        Btblis = @inferred tblis_tensor(B, β)
        tblis_tensor_add(Atblis, idxA, Btblis, idxB)

        @test B ≈ expected
    end
end

@testset "tblis_tensor_mult (eltype=$T)" for T in eltypes
    for _ in 1:20
        # ndims
        N1 = rand(0:3)
        N2 = rand(0:2)
        N3 = rand(0:2)

        # sizes
        sz1 = rand(1:4, N1)
        sz2 = rand(1:4, N2)
        sz3 = rand(1:4, N3)

        # perms
        pA = randperm(N1 + N2)
        ipA = invperm(pA)
        pB = randperm(N2 + N3)
        ipB = invperm(pB)
        pAB = randperm(N1 + N3)

        α₁ = rand(T)
        α₂ = rand(T)
        β = rand(T)
        A = N1 + N2 > 0 ? rand(T, vcat(sz1, sz2)[ipA]...) : fill(rand(T))
        B = N2 + N3 > 0 ? rand(T, vcat(sz2, sz3)[ipB]...) : fill(rand(T))
        C = N1 + N3 > 0 ? rand(T, vcat(sz1, sz3)[pAB]...) : fill(rand(T))

        Aperm = ndims(A) > 0 ? permutedims(A, tuple(pA...)) : A
        Bperm = ndims(B) > 0 ? permutedims(B, tuple(pB...)) : B
        AB = (α₁ * α₂) * reshape(reshape(Aperm, prod(sz1), prod(sz2)) *
                                 reshape(Bperm, prod(sz2), prod(sz3)),
                                 sz1..., sz3...)
        expected = ndims(C) == 0 ? AB + β * C : permutedims(AB, tuple(pAB...)) + β * C

        # actual computation stores result in C
        Atblis = tblis_tensor(A, α₁)
        Btblis = tblis_tensor(B, α₂)
        Ctblis = tblis_tensor(C, β)

        idx = string(('a' .+ (0:(N1 + N2 + N3 - 1)))...)
        idxA = idx[1:(N1 + N2)][ipA]
        idxB = idx[N1 .+ (1:(N2 + N3))][ipB]
        idxC = idx[vcat(1:N1, (N1 + N2 + 1):end)][pAB]
        tblis_tensor_mult(Atblis, idxA, Btblis, idxB, Ctblis, idxC)

        @test C ≈ expected
    end
end

end
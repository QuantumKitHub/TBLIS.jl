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

        # a full collection here would previously free the length and stride buffers that
        # were handed to TBLIS, leading to a segfault
        GC.gc(true)

        # actual computation stores result in B
        @test tblis_tensor_add(α, A, idxA, β, B, idxB) === B
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

        α = rand(T)
        β = rand(T)
        A = N1 + N2 > 0 ? rand(T, vcat(sz1, sz2)[ipA]...) : fill(rand(T))
        B = N2 + N3 > 0 ? rand(T, vcat(sz2, sz3)[ipB]...) : fill(rand(T))
        C = N1 + N3 > 0 ? rand(T, vcat(sz1, sz3)[pAB]...) : fill(rand(T))

        Aperm = ndims(A) > 0 ? permutedims(A, tuple(pA...)) : A
        Bperm = ndims(B) > 0 ? permutedims(B, tuple(pB...)) : B
        AB = α * reshape(reshape(Aperm, prod(sz1), prod(sz2)) *
                         reshape(Bperm, prod(sz2), prod(sz3)),
                         sz1..., sz3...)
        expected = ndims(C) == 0 ? AB + β * C : permutedims(AB, tuple(pAB...)) + β * C

        idx = string(('a' .+ (0:(N1 + N2 + N3 - 1)))...)
        idxA = idx[1:(N1 + N2)][ipA]
        idxB = idx[N1 .+ (1:(N2 + N3))][ipB]
        idxC = idx[vcat(1:N1, (N1 + N2 + 1):end)][pAB]

        GC.gc(true)

        # actual computation stores result in C
        @test tblis_tensor_mult(α, A, idxA, B, idxB, β, C, idxC) === C
        @test C ≈ expected
    end
end

@testset "tblis_tensor_dot (ndims=$N, eltype=$T)" for T in eltypes, N in 0:4
    for _ in 1:5 # repeat tests
        szA = rand(1:4, N)
        perm = randperm(N)

        idxA = string(('a' .+ (0:(N - 1)))...)
        idxB = idxA[perm]

        A = N > 0 ? rand(T, szA...) : fill(rand(T))
        B = N > 0 ? rand(T, szA[perm]...) : fill(rand(T))
        α = rand(T)

        # note that TBLIS does not conjugate A
        expected = α * sum(A .* permutedims(B, invperm(perm)))

        GC.gc(true)

        result = @inferred tblis_tensor_dot(α, A, idxA, B, idxB)
        @test result isa T
        @test result ≈ expected
    end
end

@testset "element type mismatch" begin
    A = rand(Float64, 2, 2)
    B = rand(Float32, 2, 2)
    @test_throws ArgumentError tblis_tensor_add(1.0, A, "ab", 1.0, B, "ab")
    @test_throws ArgumentError tblis_tensor_mult(1.0, A, "ab", A, "bc", 1.0, B, "ac")
    @test_throws ArgumentError tblis_tensor_dot(1.0, A, "ab", B, "ab")
end

end

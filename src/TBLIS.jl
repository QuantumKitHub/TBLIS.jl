module TBLIS

using tblis_jll

# Exports
export tblis_tensor, tblis_scalar
export tblis_tensor_add, tblis_tensor_mult, tblis_tensor_dot

# Julia bindings for TBLIS
# ------------------------
# some manual fixes on top of the auto-generated ones
const ptrdiff_t = Cptrdiff_t
const scomplex = ComplexF32
const dcomplex = ComplexF64

# include auto-generated lib files
const IS_LIBC_MUSL = occursin("musl", Base.BUILD_TRIPLET)
if Sys.isapple() && Sys.ARCH === :aarch64
    include("lib/aarch64-apple-darwin20.jl")
elseif Sys.islinux() && Sys.ARCH === :aarch64 && !IS_LIBC_MUSL
    include("lib/aarch64-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :aarch64 && IS_LIBC_MUSL
    include("lib/aarch64-linux-musl.jl")
elseif Sys.islinux() && startswith(string(Sys.ARCH), "arm") && !IS_LIBC_MUSL
    include("lib/armv7l-linux-gnueabihf.jl")
elseif Sys.islinux() && startswith(string(Sys.ARCH), "arm") && IS_LIBC_MUSL
    include("lib/armv7l-linux-musleabihf.jl")
elseif Sys.islinux() && Sys.ARCH === :i686 && !IS_LIBC_MUSL
    include("lib/i686-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :i686 && IS_LIBC_MUSL
    include("lib/i686-linux-musl.jl")
elseif Sys.iswindows() && Sys.ARCH === :i686
    include("lib/i686-w64-mingw32.jl")
elseif Sys.islinux() && Sys.ARCH === :powerpc64le
    include("lib/powerpc64le-linux-gnu.jl")
elseif Sys.isapple() && Sys.ARCH === :x86_64
    include("lib/x86_64-apple-darwin14.jl")
elseif Sys.islinux() && Sys.ARCH === :x86_64 && !IS_LIBC_MUSL
    include("lib/x86_64-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :x86_64 && IS_LIBC_MUSL
    include("lib/x86_64-linux-musl.jl")
    # elseif Sys.isbsd() && !Sys.isapple()
    #     include("lib/x86_64-unknown-freebsd.jl")
elseif Sys.iswindows() && Sys.ARCH === :x86_64
    include("lib/x86_64-w64-mingw32.jl")
else
    error("Unknown platform: $(Base.BUILD_TRIPLET)")
end

# Constructors and operations
# ---------------------------
@doc """
    tblis_scalar(s::Number)

Initializes a tblis scalar from a number.
""" tblis_scalar

@doc """
    tblis_tensor(A::StridedArray{T<:BlasFloat}, s::Number, szA::Vector{len_type}, strA::Vector{stride_type})

Initializes a tblis tensor that views `A` scaled by `s`, using `szA` and `strA` as the
buffers holding the lengths and strides that are handed to TBLIS.

!!! warning
    This operation is unsafe: the resulting `tblis_tensor` only stores raw pointers into
    `A`, `szA` and `strA`. The caller is responsible for keeping all three alive -- e.g.
    with `GC.@preserve` -- for as long as the tensor is passed to TBLIS. Prefer the
    array-based methods of [`tblis_tensor_add`](@ref), [`tblis_tensor_mult`](@ref) and
    [`tblis_tensor_dot`](@ref), which take care of this.
""" tblis_tensor

# length and stride buffers in the layout expected by TBLIS
_lengths(A::StridedArray) = collect(len_type, size(A))
_strides(A::StridedArray) = collect(stride_type, strides(A))

for (T, S, tblis_init_scalar, tblis_init_tensor, tblis_init_tensor_scaled) in
    ((:Float32, :s, :tblis_init_scalar_s, :tblis_init_tensor_s,
      :tblis_init_tensor_scaled_s),
     (:Float64, :d, :tblis_init_scalar_d, :tblis_init_tensor_d,
      :tblis_init_tensor_scaled_d),
     (:ComplexF32, :c, :tblis_init_scalar_c, :tblis_init_tensor_c,
      :tblis_init_tensor_scaled_c),
     (:ComplexF64, :z, :tblis_init_scalar_z, :tblis_init_tensor_z,
      :tblis_init_tensor_scaled_z))
    @eval begin
        function tblis_scalar(s::$T)
            t = Ref{tblis_scalar}()
            $tblis_init_scalar(t, s)
            return t[]
        end
        function tblis_tensor(A::StridedArray{$T,N}, s::Number,
                              szA::Vector{len_type}, strA::Vector{stride_type}) where {N}
            t = Ref{tblis_tensor}()
            GC.@preserve A szA strA begin
                if isone(s)
                    $tblis_init_tensor(t, N, pointer(szA), pointer(A), pointer(strA))
                else
                    $tblis_init_tensor_scaled(t, $T(s), N, pointer(szA), pointer(A),
                                              pointer(strA))
                end
            end
            return t[]
        end

        # the arrays and their length/stride buffers are kept alive for the entire
        # duration of the ccall, so TBLIS can never observe a dangling pointer
        function tblis_tensor_add(α::Number, A::StridedArray{$T}, idxA::AbstractString,
                                  β::Number, B::StridedArray{$T}, idxB::AbstractString)
            szA, strA = _lengths(A), _strides(A)
            szB, strB = _lengths(B), _strides(B)
            GC.@preserve A szA strA B szB strB begin
                tA = Ref(tblis_tensor(A, α, szA, strA))
                tB = Ref(tblis_tensor(B, β, szB, strB))
                tblis_tensor_add(C_NULL, C_NULL, tA, idxA, tB, idxB)
            end
            return B
        end

        function tblis_tensor_mult(α::Number, A::StridedArray{$T}, idxA::AbstractString,
                                   B::StridedArray{$T}, idxB::AbstractString,
                                   β::Number, C::StridedArray{$T}, idxC::AbstractString)
            szA, strA = _lengths(A), _strides(A)
            szB, strB = _lengths(B), _strides(B)
            szC, strC = _lengths(C), _strides(C)
            GC.@preserve A szA strA B szB strB C szC strC begin
                tA = Ref(tblis_tensor(A, α, szA, strA))
                tB = Ref(tblis_tensor(B, one($T), szB, strB))
                tC = Ref(tblis_tensor(C, β, szC, strC))
                tblis_tensor_mult(C_NULL, C_NULL, tA, idxA, tB, idxB, tC, idxC)
            end
            return C
        end

        function tblis_tensor_dot(α::Number, A::StridedArray{$T}, idxA::AbstractString,
                                  B::StridedArray{$T}, idxB::AbstractString)
            szA, strA = _lengths(A), _strides(A)
            szB, strB = _lengths(B), _strides(B)
            result = Ref(tblis_scalar(zero($T)))
            GC.@preserve A szA strA B szB strB begin
                tA = Ref(tblis_tensor(A, α, szA, strA))
                tB = Ref(tblis_tensor(B, one($T), szB, strB))
                tblis_tensor_dot(C_NULL, C_NULL, tA, idxA, tB, idxB, result)
            end
            return convert($T, getproperty(result[].data, $(QuoteNode(S))))
        end
    end
end

# Without these, mismatched or unsupported element types would fall through to the
# auto-generated low-level methods, which accept anything and fail obscurely.
@noinline function _eltype_error(As::StridedArray...)
    msg = "TBLIS requires a common element type in " *
          "(Float32, Float64, ComplexF32, ComplexF64), got " *
          join(eltype.(As), ", ")
    return throw(ArgumentError(msg))
end

function tblis_tensor_add(::Number, A::StridedArray, ::AbstractString,
                          ::Number, B::StridedArray, ::AbstractString)
    return _eltype_error(A, B)
end
function tblis_tensor_mult(::Number, A::StridedArray, ::AbstractString,
                           B::StridedArray, ::AbstractString,
                           ::Number, C::StridedArray, ::AbstractString)
    return _eltype_error(A, B, C)
end
function tblis_tensor_dot(::Number, A::StridedArray, ::AbstractString,
                          B::StridedArray, ::AbstractString)
    return _eltype_error(A, B)
end

@doc """
    tblis_tensor_add(α::Number, A::StridedArray, idxA::AbstractString,
                     β::Number, B::StridedArray, idxB::AbstractString)

Tensor operation of the form ``B[idxB] := β B[idxB] + α A[idxA]``, carried out in-place in
`B`, which is also returned.
""" tblis_tensor_add

@doc """
    tblis_tensor_mult(α::Number, A::StridedArray, idxA::AbstractString,
                      B::StridedArray, idxB::AbstractString,
                      β::Number, C::StridedArray, idxC::AbstractString)

Tensor operation of the form ``C[idxC] := β C[idxC] + α A[idxA] B[idxB]``, carried out
in-place in `C`, which is also returned.
""" tblis_tensor_mult

@doc """
    tblis_tensor_dot(α::Number, A::StridedArray, idxA::AbstractString,
                     B::StridedArray, idxB::AbstractString)

Tensor operation of the form ``α A[idxA] B[idxB]``, contracting over all indices and
returning the resulting scalar. Note that `A` is not conjugated.
""" tblis_tensor_dot

# Utility
# -------
"""
    get_num_threads()

Get the current number of threads the TBLIS library is using.
"""
get_num_threads() = convert(Int, tblis_get_num_threads())

"""
    set_num_threads(n::Int)

Set the number of threads the TBLIS library should use equal to `n`.
"""
set_num_threads(n::Integer) = tblis_set_num_threads(convert(Cuint, n))

end

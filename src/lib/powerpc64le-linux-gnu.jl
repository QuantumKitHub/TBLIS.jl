# no prototype is found for this function at yield.h:27:17, please use with caution
function tci_yield()
    @ccall tblis.tci_yield()::Cvoid
end

const tci_mutex = Cchar

function tci_mutex_init(mutex)
    @ccall tblis.tci_mutex_init(mutex::Ptr{tci_mutex})::Cint
end

function tci_mutex_destroy(mutex)
    @ccall tblis.tci_mutex_destroy(mutex::Ptr{tci_mutex})::Cint
end

function tci_mutex_lock(mutex)
    @ccall tblis.tci_mutex_lock(mutex::Ptr{tci_mutex})::Cint
end

function tci_mutexrylock(mutex)
    @ccall tblis.tci_mutexrylock(mutex::Ptr{tci_mutex})::Cint
end

function tci_mutex_unlock(mutex)
    @ccall tblis.tci_mutex_unlock(mutex::Ptr{tci_mutex})::Cint
end

struct tci_barrier_node
    parent::Ptr{tci_barrier_node}
    nchildren::Cuint
    step::Cuint
    nwaiting::Cuint
end

function tci_barrier_node_init(barrier, parent, nchildren)
    @ccall tblis.tci_barrier_node_init(barrier::Ptr{tci_barrier_node},
                                       parent::Ptr{tci_barrier_node},
                                       nchildren::Cuint)::Cint
end

function tci_barrier_node_destroy(barrier)
    @ccall tblis.tci_barrier_node_destroy(barrier::Ptr{tci_barrier_node})::Cint
end

function tci_barrier_node_wait(barrier)
    @ccall tblis.tci_barrier_node_wait(barrier::Ptr{tci_barrier_node})::Cint
end

struct var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"
    data::NTuple{24,UInt8}
end

function Base.getproperty(x::Ptr{var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"},
                          f::Symbol)
    f === :array && return Ptr{Ptr{tci_barrier_node}}(x + 0)
    f === :single && return Ptr{tci_barrier_node}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)",
                          f::Symbol)
    r = Ref{var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"}(x)
    ptr = Base.unsafe_convert(Ptr{var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"},
                              r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"},
                           f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

struct tci_barrier
    data::NTuple{40,UInt8}
end

function Base.getproperty(x::Ptr{tci_barrier}, f::Symbol)
    f === :barrier &&
        return Ptr{var"union (unnamed at /mnt/home/ldevos/.julia/artifacts/88acd4122206bc00423af187fad99a0fb01f433e/include/tci/barrier.h:43:5)"}(x +
                                                                                                                                                  0)
    f === :nthread && return Ptr{Cuint}(x + 24)
    f === :group_size && return Ptr{Cuint}(x + 28)
    f === :is_tree && return Ptr{Cint}(x + 32)
    return getfield(x, f)
end

function Base.getproperty(x::tci_barrier, f::Symbol)
    r = Ref{tci_barrier}(x)
    ptr = Base.unsafe_convert(Ptr{tci_barrier}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{tci_barrier}, f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

function tci_barrier_is_tree(barrier)
    @ccall tblis.tci_barrier_is_tree(barrier::Ptr{tci_barrier})::Cint
end

function tci_barrier_init(barrier, nthread, group_size)
    @ccall tblis.tci_barrier_init(barrier::Ptr{tci_barrier}, nthread::Cuint,
                                  group_size::Cuint)::Cint
end

function tci_barrier_destroy(barrier)
    @ccall tblis.tci_barrier_destroy(barrier::Ptr{tci_barrier})::Cint
end

function tci_barrier_wait(barrier, tid)
    @ccall tblis.tci_barrier_wait(barrier::Ptr{tci_barrier}, tid::Cuint)::Cint
end

struct tci_context
    barrier::tci_barrier
    buffer::Ptr{Cvoid}
    refcount::Cuint
end

function tci_context_init(context, nthread, group_size)
    @ccall tblis.tci_context_init(context::Ptr{Ptr{tci_context}}, nthread::Cuint,
                                  group_size::Cuint)::Cint
end

function tci_context_attach(context)
    @ccall tblis.tci_context_attach(context::Ptr{tci_context})::Cint
end

function tci_context_detach(context)
    @ccall tblis.tci_context_detach(context::Ptr{tci_context})::Cint
end

function tci_context_barrier(context, tid)
    @ccall tblis.tci_context_barrier(context::Ptr{tci_context}, tid::Cuint)::Cint
end

function tci_context_send(context, tid, object)
    @ccall tblis.tci_context_send(context::Ptr{tci_context}, tid::Cuint,
                                  object::Ptr{Cvoid})::Cint
end

function tci_context_send_nowait(context, tid, object)
    @ccall tblis.tci_context_send_nowait(context::Ptr{tci_context}, tid::Cuint,
                                         object::Ptr{Cvoid})::Cint
end

function tci_context_receive(context, tid, object)
    @ccall tblis.tci_context_receive(context::Ptr{tci_context}, tid::Cuint,
                                     object::Ptr{Ptr{Cvoid}})::Cint
end

function tci_context_receive_nowait(context, tid, object)
    @ccall tblis.tci_context_receive_nowait(context::Ptr{tci_context}, tid::Cuint,
                                            object::Ptr{Ptr{Cvoid}})::Cint
end

struct tci_comm
    context::Ptr{tci_context}
    ngang::Cuint
    gid::Cuint
    nthread::Cuint
    tid::Cuint
end

@enum __JL_Ctag_1::UInt32 begin
    TCI_EVENLY = 2
    TCI_CYCLIC = 4
    TCI_BLOCK_CYCLIC = 6
    TCI_BLOCKED = 8
    TCI_NO_CONTEXT = 1
end

mutable struct tci_range
    size::UInt64
    grain::UInt64
    tci_range() = new()
end

# typedef void ( * tci_range_func ) ( tci_comm * , uint64_t , uint64_t , void * )
const tci_range_func = Ptr{Cvoid}

# typedef void ( * tci_range_2d_func ) ( tci_comm * , uint64_t , uint64_t , uint64_t , uint64_t , void * )
const tci_range_2d_func = Ptr{Cvoid}

function tci_comm_init_single(comm)
    @ccall tblis.tci_comm_init_single(comm::Ptr{tci_comm})::Cint
end

function tci_comm_init(comm, context, nthread, tid, ngang, gid)
    @ccall tblis.tci_comm_init(comm::Ptr{tci_comm}, context::Ptr{tci_context},
                               nthread::Cuint, tid::Cuint, ngang::Cuint, gid::Cuint)::Cint
end

function tci_comm_destroy(comm)
    @ccall tblis.tci_comm_destroy(comm::Ptr{tci_comm})::Cint
end

function tci_comm_is_master(comm)
    @ccall tblis.tci_comm_is_master(comm::Ptr{tci_comm})::Cint
end

function tci_comm_barrier(comm)
    @ccall tblis.tci_comm_barrier(comm::Ptr{tci_comm})::Cint
end

function tci_comm_bcast(comm, object, root)
    @ccall tblis.tci_comm_bcast(comm::Ptr{tci_comm}, object::Ptr{Ptr{Cvoid}},
                                root::Cuint)::Cint
end

function tci_comm_bcast_nowait(comm, object, root)
    @ccall tblis.tci_comm_bcast_nowait(comm::Ptr{tci_comm}, object::Ptr{Ptr{Cvoid}},
                                       root::Cuint)::Cint
end

function tci_comm_gang(parent, child, type, n, bs)
    @ccall tblis.tci_comm_gang(parent::Ptr{tci_comm}, child::Ptr{tci_comm}, type::Cint,
                               n::Cuint, bs::Cuint)::Cint
end

function tci_comm_distribute_over_gangs(comm, range, func, payload)
    @ccall tblis.tci_comm_distribute_over_gangs(comm::Ptr{tci_comm}, range::tci_range,
                                                func::tci_range_func,
                                                payload::Ptr{Cvoid})::Cvoid
end

function tci_comm_distribute_over_threads(comm, range, func, payload)
    @ccall tblis.tci_comm_distribute_over_threads(comm::Ptr{tci_comm}, range::tci_range,
                                                  func::tci_range_func,
                                                  payload::Ptr{Cvoid})::Cvoid
end

function tci_comm_distribute_over_gangs_2d(comm, range_m, range_n, func, payload)
    @ccall tblis.tci_comm_distribute_over_gangs_2d(comm::Ptr{tci_comm}, range_m::tci_range,
                                                   range_n::tci_range,
                                                   func::tci_range_2d_func,
                                                   payload::Ptr{Cvoid})::Cvoid
end

function tci_comm_distribute_over_threads_2d(comm, range_m, range_n, func, payload)
    @ccall tblis.tci_comm_distribute_over_threads_2d(comm::Ptr{tci_comm},
                                                     range_m::tci_range, range_n::tci_range,
                                                     func::tci_range_2d_func,
                                                     payload::Ptr{Cvoid})::Cvoid
end

# typedef void ( * tci_thread_func ) ( tci_comm * , void * )
const tci_thread_func = Ptr{Cvoid}

function tci_parallelize(func, payload, nthread, arity)
    @ccall tblis.tci_parallelize(func::tci_thread_func, payload::Ptr{Cvoid}, nthread::Cuint,
                                 arity::Cuint)::Cint
end

struct tci_prime_factors
    n::Cuint
    sqrt_n::Cuint
    f::Cuint
end

function tci_prime_factorization(n, factors)
    @ccall tblis.tci_prime_factorization(n::Cuint, factors::Ptr{tci_prime_factors})::Cvoid
end

function tci_next_prime_factor(factors)
    @ccall tblis.tci_next_prime_factor(factors::Ptr{tci_prime_factors})::Cuint
end

function tci_partition_2x2(nthread, work1, max1, work2, max2, nt1, nt2)
    @ccall tblis.tci_partition_2x2(nthread::Cuint, work1::UInt64, max1::Cuint,
                                   work2::UInt64, max2::Cuint, nt1::Ptr{Cuint},
                                   nt2::Ptr{Cuint})::Cvoid
end

const tci_slot = Cint

function tci_slot_init(slot, empty)
    @ccall tblis.tci_slot_init(slot::Ptr{tci_slot}, empty::Cint)::Cint
end

function tci_slot_is_filled(slot, empty)
    @ccall tblis.tci_slot_is_filled(slot::Ptr{tci_slot}, empty::Cint)::Cint
end

function tci_slot_try_fill(slot, empty, value)
    @ccall tblis.tci_slot_try_fill(slot::Ptr{tci_slot}, empty::Cint, value::Cint)::Cint
end

function tci_slot_fill(slot, empty, value)
    @ccall tblis.tci_slot_fill(slot::Ptr{tci_slot}, empty::Cint, value::Cint)::Cvoid
end

function tci_slot_clear(slot, empty)
    @ccall tblis.tci_slot_clear(slot::Ptr{tci_slot}, empty::Cint)::Cvoid
end

@enum __JL_Ctag_2::UInt32 begin
    TCI_NOT_WORKED_ON = 0
    TCI_IN_PROGRESS = 1
    TCI_RESERVED = 2
    TCI_FINISHED = 3
end

const tci_work_item = Cint

function tci_work_item_try_work(item)
    @ccall tblis.tci_work_item_try_work(item::Ptr{tci_work_item})::Cint
end

function tci_work_item_finish(item)
    @ccall tblis.tci_work_item_finish(item::Ptr{tci_work_item})::Cvoid
end

function tci_work_item_status(item)
    @ccall tblis.tci_work_item_status(item::Ptr{tci_work_item})::Cint
end

function tci_work_item_wait(item)
    @ccall tblis.tci_work_item_wait(item::Ptr{tci_work_item})::Cvoid
end

mutable struct tblis_config_s end

const tblis_config = tblis_config_s

@enum reduce_t::UInt32 begin
    REDUCE_SUM = 0
    REDUCE_SUM_ABS = 1
    REDUCE_MAX = 2
    REDUCE_MAX_ABS = 3
    REDUCE_MIN = 4
    REDUCE_MIN_ABS = 5
    # REDUCE_NORM_1 = 1
    REDUCE_NORM_2 = 6
    # REDUCE_NORM_INF = 3
end

@enum type_t::UInt32 begin
    TYPE_SINGLE = 0
    # TYPE_FLOAT = 0
    TYPE_DOUBLE = 1
    TYPE_SCOMPLEX = 2
    TYPE_DCOMPLEX = 3
end

const len_type = Cptrdiff_t

const stride_type = Cptrdiff_t

const label_type = Cchar

mutable struct fake_scomplex
    real::Cfloat
    imag::Cfloat
    fake_scomplex() = new()
end

mutable struct fake_dcomplex
    real::Cdouble
    imag::Cdouble
    fake_dcomplex() = new()
end

struct scalar
    data::NTuple{16,UInt8}
end

function Base.getproperty(x::Ptr{scalar}, f::Symbol)
    f === :s && return Ptr{Cfloat}(x + 0)
    f === :d && return Ptr{Cdouble}(x + 0)
    f === :c && return Ptr{scomplex}(x + 0)
    f === :z && return Ptr{dcomplex}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::scalar, f::Symbol)
    r = Ref{scalar}(x)
    ptr = Base.unsafe_convert(Ptr{scalar}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{scalar}, f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

struct tblis_scalar
    data::NTuple{24,UInt8}
end

function Base.getproperty(x::Ptr{tblis_scalar}, f::Symbol)
    f === :data && return Ptr{scalar}(x + 0)
    f === :type && return Ptr{type_t}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::tblis_scalar, f::Symbol)
    r = Ref{tblis_scalar}(x)
    ptr = Base.unsafe_convert(Ptr{tblis_scalar}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{tblis_scalar}, f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

function tblis_init_scalar_s(s, value)
    @ccall tblis.tblis_init_scalar_s(s::Ptr{tblis_scalar}, value::Cfloat)::Cvoid
end

function tblis_init_scalar_d(s, value)
    @ccall tblis.tblis_init_scalar_d(s::Ptr{tblis_scalar}, value::Cdouble)::Cvoid
end

function tblis_init_scalar_c(s, value)
    @ccall tblis.tblis_init_scalar_c(s::Ptr{tblis_scalar}, value::scomplex)::Cvoid
end

function tblis_init_scalar_z(s, value)
    @ccall tblis.tblis_init_scalar_z(s::Ptr{tblis_scalar}, value::dcomplex)::Cvoid
end

mutable struct tblis_vector
    type::type_t
    conj::Cint
    scalar::tblis_scalar
    data::Ptr{Cvoid}
    n::len_type
    inc::stride_type
    tblis_vector() = new()
end

function tblis_init_vector_scaled_s(v, scalar_, n, data, inc)
    @ccall tblis.tblis_init_vector_scaled_s(v::Ptr{tblis_vector}, scalar_::Cfloat,
                                            n::len_type, data::Ptr{Cfloat},
                                            inc::stride_type)::Cvoid
end

function tblis_init_vector_scaled_d(v, scalar_, n, data, inc)
    @ccall tblis.tblis_init_vector_scaled_d(v::Ptr{tblis_vector}, scalar_::Cdouble,
                                            n::len_type, data::Ptr{Cdouble},
                                            inc::stride_type)::Cvoid
end

function tblis_init_vector_scaled_c(v, scalar_, n, data, inc)
    @ccall tblis.tblis_init_vector_scaled_c(v::Ptr{tblis_vector}, scalar_::scomplex,
                                            n::len_type, data::Ptr{scomplex},
                                            inc::stride_type)::Cvoid
end

function tblis_init_vector_scaled_z(v, scalar_, n, data, inc)
    @ccall tblis.tblis_init_vector_scaled_z(v::Ptr{tblis_vector}, scalar_::dcomplex,
                                            n::len_type, data::Ptr{dcomplex},
                                            inc::stride_type)::Cvoid
end

function tblis_init_vector_s(v, n, data, inc)
    @ccall tblis.tblis_init_vector_s(v::Ptr{tblis_vector}, n::len_type, data::Ptr{Cfloat},
                                     inc::stride_type)::Cvoid
end

function tblis_init_vector_d(v, n, data, inc)
    @ccall tblis.tblis_init_vector_d(v::Ptr{tblis_vector}, n::len_type, data::Ptr{Cdouble},
                                     inc::stride_type)::Cvoid
end

function tblis_init_vector_c(v, n, data, inc)
    @ccall tblis.tblis_init_vector_c(v::Ptr{tblis_vector}, n::len_type, data::Ptr{scomplex},
                                     inc::stride_type)::Cvoid
end

function tblis_init_vector_z(v, n, data, inc)
    @ccall tblis.tblis_init_vector_z(v::Ptr{tblis_vector}, n::len_type, data::Ptr{dcomplex},
                                     inc::stride_type)::Cvoid
end

mutable struct tblis_matrix
    type::type_t
    conj::Cint
    scalar::tblis_scalar
    data::Ptr{Cvoid}
    m::len_type
    n::len_type
    rs::stride_type
    cs::stride_type
    tblis_matrix() = new()
end

function tblis_init_matrix_scaled_s(mat, scalar_, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_scaled_s(mat::Ptr{tblis_matrix}, scalar_::Cfloat,
                                            m::len_type, n::len_type, data::Ptr{Cfloat},
                                            rs::stride_type, cs::stride_type)::Cvoid
end

function tblis_init_matrix_scaled_d(mat, scalar_, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_scaled_d(mat::Ptr{tblis_matrix}, scalar_::Cdouble,
                                            m::len_type, n::len_type, data::Ptr{Cdouble},
                                            rs::stride_type, cs::stride_type)::Cvoid
end

function tblis_init_matrix_scaled_c(mat, scalar_, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_scaled_c(mat::Ptr{tblis_matrix}, scalar_::scomplex,
                                            m::len_type, n::len_type, data::Ptr{scomplex},
                                            rs::stride_type, cs::stride_type)::Cvoid
end

function tblis_init_matrix_scaled_z(mat, scalar_, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_scaled_z(mat::Ptr{tblis_matrix}, scalar_::dcomplex,
                                            m::len_type, n::len_type, data::Ptr{dcomplex},
                                            rs::stride_type, cs::stride_type)::Cvoid
end

function tblis_init_matrix_s(mat, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_s(mat::Ptr{tblis_matrix}, m::len_type, n::len_type,
                                     data::Ptr{Cfloat}, rs::stride_type,
                                     cs::stride_type)::Cvoid
end

function tblis_init_matrix_d(mat, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_d(mat::Ptr{tblis_matrix}, m::len_type, n::len_type,
                                     data::Ptr{Cdouble}, rs::stride_type,
                                     cs::stride_type)::Cvoid
end

function tblis_init_matrix_c(mat, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_c(mat::Ptr{tblis_matrix}, m::len_type, n::len_type,
                                     data::Ptr{scomplex}, rs::stride_type,
                                     cs::stride_type)::Cvoid
end

function tblis_init_matrix_z(mat, m, n, data, rs, cs)
    @ccall tblis.tblis_init_matrix_z(mat::Ptr{tblis_matrix}, m::len_type, n::len_type,
                                     data::Ptr{dcomplex}, rs::stride_type,
                                     cs::stride_type)::Cvoid
end

struct tblis_tensor
    type::type_t
    conj::Cint
    scalar::tblis_scalar
    data::Ptr{Cvoid}
    ndim::Cuint
    len::Ptr{len_type}
    stride::Ptr{stride_type}
end

function tblis_init_tensor_scaled_s(t, scalar_, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_scaled_s(t::Ptr{tblis_tensor}, scalar_::Cfloat,
                                            ndim::Cuint, len::Ptr{len_type},
                                            data::Ptr{Cfloat},
                                            stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_scaled_d(t, scalar_, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_scaled_d(t::Ptr{tblis_tensor}, scalar_::Cdouble,
                                            ndim::Cuint, len::Ptr{len_type},
                                            data::Ptr{Cdouble},
                                            stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_scaled_c(t, scalar_, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_scaled_c(t::Ptr{tblis_tensor}, scalar_::scomplex,
                                            ndim::Cuint, len::Ptr{len_type},
                                            data::Ptr{scomplex},
                                            stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_scaled_z(t, scalar_, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_scaled_z(t::Ptr{tblis_tensor}, scalar_::dcomplex,
                                            ndim::Cuint, len::Ptr{len_type},
                                            data::Ptr{dcomplex},
                                            stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_s(t, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_s(t::Ptr{tblis_tensor}, ndim::Cuint, len::Ptr{len_type},
                                     data::Ptr{Cfloat}, stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_d(t, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_d(t::Ptr{tblis_tensor}, ndim::Cuint, len::Ptr{len_type},
                                     data::Ptr{Cdouble}, stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_c(t, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_c(t::Ptr{tblis_tensor}, ndim::Cuint, len::Ptr{len_type},
                                     data::Ptr{scomplex}, stride::Ptr{stride_type})::Cvoid
end

function tblis_init_tensor_z(t, ndim, len, data, stride)
    @ccall tblis.tblis_init_tensor_z(t::Ptr{tblis_tensor}, ndim::Cuint, len::Ptr{len_type},
                                     data::Ptr{dcomplex}, stride::Ptr{stride_type})::Cvoid
end

function tblis_get_config(name)
    @ccall tblis.tblis_get_config(name::Ptr{Cchar})::Ptr{tblis_config}
end

const tblis_comm = tci_comm

# no prototype is found for this function at thread.h:21:10, please use with caution
function tblis_get_num_threads()
    @ccall tblis.tblis_get_num_threads()::Cuint
end

function tblis_set_num_threads(num_threads)
    @ccall tblis.tblis_set_num_threads(num_threads::Cuint)::Cvoid
end

function tblis_vector_add(comm, cfg, A, B)
    @ccall tblis.tblis_vector_add(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_vector}, B::Ptr{tblis_vector})::Cvoid
end

function tblis_vector_dot(comm, cfg, A, B, result)
    @ccall tblis.tblis_vector_dot(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_vector}, B::Ptr{tblis_vector},
                                  result::Ptr{tblis_scalar})::Cvoid
end

function tblis_vector_reduce(comm, cfg, op, A, result, idx)
    @ccall tblis.tblis_vector_reduce(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                     op::reduce_t, A::Ptr{tblis_vector},
                                     result::Ptr{tblis_scalar}, idx::Ptr{len_type})::Cvoid
end

function tblis_vector_scale(comm, cfg, A)
    @ccall tblis.tblis_vector_scale(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                    A::Ptr{tblis_vector})::Cvoid
end

function tblis_vector_set(comm, cfg, alpha, A)
    @ccall tblis.tblis_vector_set(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  alpha::Ptr{tblis_scalar}, A::Ptr{tblis_vector})::Cvoid
end

function tblis_matrix_add(comm, cfg, A, B)
    @ccall tblis.tblis_matrix_add(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_matrix}, B::Ptr{tblis_matrix})::Cvoid
end

function tblis_matrix_dot(comm, cfg, A, B, result)
    @ccall tblis.tblis_matrix_dot(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_matrix}, B::Ptr{tblis_matrix},
                                  result::Ptr{tblis_scalar})::Cvoid
end

function tblis_matrix_reduce(comm, cfg, op, A, result, idx)
    @ccall tblis.tblis_matrix_reduce(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                     op::reduce_t, A::Ptr{tblis_matrix},
                                     result::Ptr{tblis_scalar}, idx::Ptr{len_type})::Cvoid
end

function tblis_matrix_scale(comm, cfg, A)
    @ccall tblis.tblis_matrix_scale(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                    A::Ptr{tblis_matrix})::Cvoid
end

function tblis_matrix_set(comm, cfg, alpha, A)
    @ccall tblis.tblis_matrix_set(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  alpha::Ptr{tblis_scalar}, A::Ptr{tblis_matrix})::Cvoid
end

function tblis_tensor_add(comm, cfg, A, idx_A, B, idx_B)
    @ccall tblis.tblis_tensor_add(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_tensor}, idx_A::Ptr{label_type},
                                  B::Ptr{tblis_tensor}, idx_B::Ptr{label_type})::Cvoid
end

function tblis_tensor_dot(comm, cfg, A, idx_A, B, idx_B, result)
    @ccall tblis.tblis_tensor_dot(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  A::Ptr{tblis_tensor}, idx_A::Ptr{label_type},
                                  B::Ptr{tblis_tensor}, idx_B::Ptr{label_type},
                                  result::Ptr{tblis_scalar})::Cvoid
end

function tblis_tensor_reduce(comm, cfg, op, A, idx_A, result, idx)
    @ccall tblis.tblis_tensor_reduce(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                     op::reduce_t, A::Ptr{tblis_tensor},
                                     idx_A::Ptr{label_type}, result::Ptr{tblis_scalar},
                                     idx::Ptr{len_type})::Cvoid
end

function tblis_tensor_scale(comm, cfg, A, idx_A)
    @ccall tblis.tblis_tensor_scale(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                    A::Ptr{tblis_tensor}, idx_A::Ptr{label_type})::Cvoid
end

function tblis_tensor_set(comm, cfg, alpha, A, idx_A)
    @ccall tblis.tblis_tensor_set(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                  alpha::Ptr{tblis_scalar}, A::Ptr{tblis_tensor},
                                  idx_A::Ptr{label_type})::Cvoid
end

function tblis_matrix_mult(comm, cfg, A, B, C)
    @ccall tblis.tblis_matrix_mult(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                   A::Ptr{tblis_matrix}, B::Ptr{tblis_matrix},
                                   C::Ptr{tblis_matrix})::Cvoid
end

function tblis_matrix_mult_diag(comm, cfg, A, D, B, C)
    @ccall tblis.tblis_matrix_mult_diag(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                        A::Ptr{tblis_matrix}, D::Ptr{tblis_vector},
                                        B::Ptr{tblis_matrix}, C::Ptr{tblis_matrix})::Cvoid
end

function tblis_tensor_mult(comm, cfg, A, idx_A, B, idx_B, C, idx_C)
    @ccall tblis.tblis_tensor_mult(comm::Ptr{tblis_comm}, cfg::Ptr{tblis_config},
                                   A::Ptr{tblis_tensor}, idx_A::Ptr{label_type},
                                   B::Ptr{tblis_tensor}, idx_B::Ptr{label_type},
                                   C::Ptr{tblis_tensor}, idx_C::Ptr{label_type})::Cvoid
end

const TCI_USE_ATOMIC_SPINLOCK = 1

const TCI_USE_OMP_LOCK = 0

const TCI_USE_OPENMP_THREADS = 1

const TCI_USE_WINDOWS_THREADS = 0

const TCI_USE_TBB_THREADS = 0

const TCI_USE_PPL_THREADS = 0

const TCI_USE_OMPTASK_THREADS = 0

const TCI_USE_DISPATCH_THREADS = 0

const TCI_USE_OSX_SPINLOCK = 0

const TCI_USE_PTHREADS_THREADS = 0

const TCI_USE_PTHREAD_BARRIER = 0

const TCI_USE_PTHREAD_MUTEX = 0

const TCI_USE_PTHREAD_SPINLOCK = 0

const TCI_USE_SPIN_BARRIER = 1

const TCI_ARCH_PPC64 = 1

# Skipping MacroDefinition: TCI_INLINE static inline

const TBLIS_HAVE_SYSCONF = 1

const TBLIS_HAVE_SYSCTL = 1

const TBLIS_HAVE__SC_NPROCESSORS_CONF = 1

const TBLIS_HAVE__SC_NPROCESSORS_ONLN = 1

const TBLIS_LABEL_TYPE = Cchar

const TBLIS_LEN_TYPE = ptrdiff_t

const TBLIS_LT_OBJDIR = ".libs/"

const TBLIS_PACKAGE = "tblis"

const TBLIS_PACKAGE_BUGREPORT = "dmatthews@utexas.edu"

const TBLIS_PACKAGE_NAME = "tblis"

const TBLIS_PACKAGE_STRING = "tblis 1.2.0"

const TBLIS_PACKAGE_TARNAME = "tblis"

const TBLIS_PACKAGE_URL = "http://www.github.com/devinamatthews/tblis"

const TBLIS_PACKAGE_VERSION = "1.2.0"

# Skipping MacroDefinition: _tblis_restrict __restrict

const TBLIS_STDC_HEADERS = 1

const TBLIS_STRIDE_TYPE = ptrdiff_t

const TBLIS_TOPDIR = "/workspace/srcdir/tblis"

const TBLIS_VERSION = "1.2.0"

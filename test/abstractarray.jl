# This file is a part of Julia. License is MIT: https://julialang.org/license

A = rand(5,4,3)
@testset "Bounds checking" begin
    @test checkbounds(Bool, A, 1, 1, 1) == true
    @test checkbounds(Bool, A, 5, 4, 3) == true
    @test checkbounds(Bool, A, 0, 1, 1) == false
    @test checkbounds(Bool, A, 1, 0, 1) == false
    @test checkbounds(Bool, A, 1, 1, 0) == false
    @test checkbounds(Bool, A, 6, 4, 3) == false
    @test checkbounds(Bool, A, 5, 5, 3) == false
    @test checkbounds(Bool, A, 5, 4, 4) == false
    @test checkbounds(Bool, A, 1) == true           # linear indexing
    @test checkbounds(Bool, A, 60) == true
    @test checkbounds(Bool, A, 61) == false
    @test checkbounds(Bool, A, 2, 2, 2, 1) == true  # extra indices
    @test checkbounds(Bool, A, 2, 2, 2, 2) == false
    # @test checkbounds(Bool, A, 1, 1)  == false       # TODO: partial linear indexing (PLI)
    # @test checkbounds(Bool, A, 1, 12) == false
    # @test checkbounds(Bool, A, 5, 12) == false
    # @test checkbounds(Bool, A, 1, 13) == false
    # @test checkbounds(Bool, A, 6, 12) == false
end

@testset "single CartesianIndex" begin
    @test checkbounds(Bool, A, CartesianIndex((1, 1, 1))) == true
    @test checkbounds(Bool, A, CartesianIndex((5, 4, 3))) == true
    @test checkbounds(Bool, A, CartesianIndex((0, 1, 1))) == false
    @test checkbounds(Bool, A, CartesianIndex((1, 0, 1))) == false
    @test checkbounds(Bool, A, CartesianIndex((1, 1, 0))) == false
    @test checkbounds(Bool, A, CartesianIndex((6, 4, 3))) == false
    @test checkbounds(Bool, A, CartesianIndex((5, 5, 3))) == false
    @test checkbounds(Bool, A, CartesianIndex((5, 4, 4))) == false
    # @test checkbounds(Bool, A, CartesianIndex((1,))) == false # TODO: PLI
    # @test checkbounds(Bool, A, CartesianIndex((60,))) == false
    # @test checkbounds(Bool, A, CartesianIndex((61,))) == false
    @test checkbounds(Bool, A, CartesianIndex((2, 2, 2, 1,))) == true
    @test checkbounds(Bool, A, CartesianIndex((2, 2, 2, 2,))) == false
    # @test checkbounds(Bool, A, CartesianIndex((1, 1,)))  == false # TODO: PLI
    # @test checkbounds(Bool, A, CartesianIndex((1, 12,))) == false
    # @test checkbounds(Bool, A, CartesianIndex((5, 12,))) == false
    # @test checkbounds(Bool, A, CartesianIndex((1, 13,))) == false
    # @test checkbounds(Bool, A, CartesianIndex((6, 12,))) == false
end

@testset "mix of CartesianIndex and Int" begin
    @test checkbounds(Bool, A, CartesianIndex((1,)), 1, CartesianIndex((1,))) == true
    @test checkbounds(Bool, A, CartesianIndex((5, 4)), 3)  == true
    @test checkbounds(Bool, A, CartesianIndex((0, 1)), 1)  == false
    @test checkbounds(Bool, A, 1, CartesianIndex((0, 1)))  == false
    @test checkbounds(Bool, A, 1, 1, CartesianIndex((0,))) == false
    @test checkbounds(Bool, A, 6, CartesianIndex((4, 3)))  == false
    @test checkbounds(Bool, A, 5, CartesianIndex((5,)), 3) == false
    @test checkbounds(Bool, A, CartesianIndex((5,)), CartesianIndex((4,)), CartesianIndex((4,)))  == false
end

@testset "vector indices" begin
    @test checkbounds(Bool, A, 1:5, 1:4, 1:3) == true
    @test checkbounds(Bool, A, 0:5, 1:4, 1:3) == false
    @test checkbounds(Bool, A, 1:5, 0:4, 1:3) == false
    @test checkbounds(Bool, A, 1:5, 1:4, 0:3) == false
    @test checkbounds(Bool, A, 1:6, 1:4, 1:3) == false
    @test checkbounds(Bool, A, 1:5, 1:5, 1:3) == false
    @test checkbounds(Bool, A, 1:5, 1:4, 1:4) == false
    @test checkbounds(Bool, A, 1:60) == true
    @test checkbounds(Bool, A, 1:61) == false
    @test checkbounds(Bool, A, 2, 2, 2, 1:1) == true  # extra indices
    @test checkbounds(Bool, A, 2, 2, 2, 1:2) == false
    # @test checkbounds(Bool, A, 1:5, 1:4) == false # TODO: PLI
    # @test checkbounds(Bool, A, 1:5, 1:12) == false
    # @test checkbounds(Bool, A, 1:5, 1:13) == false
    # @test checkbounds(Bool, A, 1:6, 1:12) == false
end

@testset "logical" begin
    @test checkbounds(Bool, A, trues(5), trues(4), trues(3)) == true
    @test checkbounds(Bool, A, trues(6), trues(4), trues(3)) == false
    @test checkbounds(Bool, A, trues(5), trues(5), trues(3)) == false
    @test checkbounds(Bool, A, trues(5), trues(4), trues(4)) == false
    @test checkbounds(Bool, A, trues(60)) == true
    @test checkbounds(Bool, A, trues(61)) == false
    @test checkbounds(Bool, A, 2, 2, 2, trues(1)) == true  # extra indices
    @test checkbounds(Bool, A, 2, 2, 2, trues(2)) == false
    # @test checkbounds(Bool, A, trues(5), trues(12)) == false # TODO: PLI
    # @test checkbounds(Bool, A, trues(5), trues(13)) == false
    # @test checkbounds(Bool, A, trues(6), trues(12)) == false
    @test checkbounds(Bool, A, trues(5, 4, 3)) == true
    @test checkbounds(Bool, A, trues(5, 4, 2)) == false
    @test checkbounds(Bool, A, trues(5, 12)) == false
    @test checkbounds(Bool, A, trues(1, 5), trues(1, 4, 1), trues(1, 1, 3)) == false
    @test checkbounds(Bool, A, trues(1, 5), trues(1, 4, 1), trues(1, 1, 2)) == false
    @test checkbounds(Bool, A, trues(1, 5), trues(1, 5, 1), trues(1, 1, 3)) == false
    @test checkbounds(Bool, A, trues(1, 5), :, 2) == false
end

@testset "array of CartesianIndex" begin
    @test checkbounds(Bool, A, [CartesianIndex((1, 1, 1))]) == true
    @test checkbounds(Bool, A, [CartesianIndex((5, 4, 3))]) == true
    @test checkbounds(Bool, A, [CartesianIndex((0, 1, 1))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((1, 0, 1))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((1, 1, 0))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((6, 4, 3))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((5, 5, 3))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((5, 4, 4))]) == false
    @test checkbounds(Bool, A, [CartesianIndex((1, 1))], 1) == true
    @test checkbounds(Bool, A, [CartesianIndex((5, 4))], 3) == true
    @test checkbounds(Bool, A, [CartesianIndex((0, 1))], 1) == false
    @test checkbounds(Bool, A, [CartesianIndex((1, 0))], 1) == false
    @test checkbounds(Bool, A, [CartesianIndex((1, 1))], 0) == false
    @test checkbounds(Bool, A, [CartesianIndex((6, 4))], 3) == false
    @test checkbounds(Bool, A, [CartesianIndex((5, 5))], 3) == false
    @test checkbounds(Bool, A, [CartesianIndex((5, 4))], 4) == false
end

@testset "sub2ind & ind2sub" begin
    @testset "0-dimensional" begin
        for i = 1:4
            @test sub2ind((), i) == i
        end
        @test sub2ind((), 2, 2) == 3
        @test ind2sub((), 1) == ()
        @test_throws BoundsError ind2sub((), 2)
    end

    @testset "1-dimensional" begin
        for i = 1:4
            @test sub2ind((3,), i) == i
            @test ind2sub((3,), i) == (i,)
        end
        @test sub2ind((3,), 2, 2) == 5
        @test_throws MethodError ind2sub((3,), 2, 2)
        #   ambiguity btw cartesian indexing and linear indexing in 1d when
        #   indices may be nontraditional
        @test_throws ArgumentError sub2ind((1:3,), 2)
        @test_throws ArgumentError ind2sub((1:3,), 2)
    end

    @testset "2-dimensional" begin
        k = 0
        for j = 1:3, i = 1:4
            @test sub2ind((4,3), i, j) == (k+=1)
            @test ind2sub((4,3), k) == (i,j)
            @test sub2ind((1:4,1:3), i, j) == k
            @test ind2sub((1:4,1:3), k) == (i,j)
            @test sub2ind((0:3,3:5), i-1, j+2) == k
            @test ind2sub((0:3,3:5), k) == (i-1, j+2)
        end
    end

    @testset "3-dimensional" begin
        l = 0
        for k = 1:2, j = 1:3, i = 1:4
            @test sub2ind((4,3,2), i, j, k) == (l+=1)
            @test ind2sub((4,3,2), l) == (i,j,k)
            @test sub2ind((1:4,1:3,1:2), i, j, k) == l
            @test ind2sub((1:4,1:3,1:2), l) == (i,j,k)
            @test sub2ind((0:3,3:5,-101:-100), i-1, j+2, k-102) == l
            @test ind2sub((0:3,3:5,-101:-100), l) == (i-1, j+2, k-102)
        end

        local A = reshape(collect(1:9), (3,3))
        @test ind2sub(size(A), 6) == (3,2)
        @test sub2ind(size(A), 3, 2) == 6
        @test ind2sub(A, 6) == (3,2)
        @test sub2ind(A, 3, 2) == 6

        @testset "PR #9256" begin
            function pr9256()
                m = [1 2 3; 4 5 6; 7 8 9]
                ind2sub(m, 6)
            end
            @test pr9256() == (3,2)
        end
    end
end

# token type on which to dispatch testing methods in order to avoid potential
# name conflicts elsewhere in the base test suite
mutable struct TestAbstractArray end

## Tests for the abstract array interfaces with minimally defined array types

# A custom linear fast array type with 24 elements that doesn't rely upon Array storage
mutable struct T24Linear{T,N,dims} <: AbstractArray{T,N}
    v1::T;  v2::T;  v3::T;  v4::T;  v5::T;  v6::T;  v7::T;  v8::T
    v9::T;  v10::T; v11::T; v12::T; v13::T; v14::T; v15::T; v16::T
    v17::T; v18::T; v19::T; v20::T; v21::T; v22::T; v23::T; v24::T
    T24Linear{T,N,d}() where {T,N,d} =
        (prod(d) == 24 || throw(DimensionMismatch("T24Linear must have 24 elements")); new())
    function T24Linear{T,N,d}(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,
                              v13,v14,v15,v16,v17,v18,v19,v20,v21,v22,v23,v24) where {T,N,d}
        prod(d) == 24 || throw(DimensionMismatch("T24Linear must have 24 elements"))
        new(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16,v17,v18,v19,v20,v21,v22,v23,v24)
    end
end

T24Linear(::Type{T}, dims::Int...) where T = T24Linear(T, dims)
T24Linear(::Type{T}, dims::NTuple{N,Int}) where {T,N} = T24Linear{T,N,dims}()

Base.convert(::Type{T24Linear     }, X::AbstractArray{T,N}) where {T,N  } = convert(T24Linear{T,N}, X)
Base.convert(::Type{T24Linear{T  }}, X::AbstractArray{_,N}) where {T,N,_} = convert(T24Linear{T,N}, X)
Base.convert(::Type{T24Linear{T,N}}, X::AbstractArray     ) where {T,N  } = T24Linear{T,N,size(X)}(X...)

Base.size(::T24Linear{T,N,dims}) where {T,N,dims} = dims
import Base: IndexLinear
Base.IndexStyle(::Type{A}) where {A<:T24Linear} = IndexLinear()
Base.getindex(A::T24Linear, i::Int) = getfield(A, i)
Base.setindex!(A::T24Linear{T}, v, i::Int) where {T} = setfield!(A, i, convert(T, v))

# A custom linear slow sparse-like array that relies upon Dict for its storage
struct TSlow{T,N} <: AbstractArray{T,N}
    data::Dict{NTuple{N,Int}, T}
    dims::NTuple{N,Int}
end
TSlow(::Type{T}, dims::Int...) where {T} = TSlow(T, dims)
TSlow(::Type{T}, dims::NTuple{N,Int}) where {T,N} = TSlow{T,N}(Dict{NTuple{N,Int}, T}(), dims)

Base.convert(::Type{TSlow{T,N}}, X::TSlow{T,N})         where {T,N  } = X
Base.convert(::Type{TSlow     }, X::AbstractArray{T,N}) where {T,N  } = convert(TSlow{T,N}, X)
Base.convert(::Type{TSlow{T  }}, X::AbstractArray{_,N}) where {T,N,_} = convert(TSlow{T,N}, X)
Base.convert(::Type{TSlow{T,N}}, X::AbstractArray     ) where {T,N  } = begin
    A = TSlow(T, size(X))
    for I in CartesianRange(size(X))
        A[I.I...] = X[I.I...]
    end
    A
end

Base.size(A::TSlow) = A.dims
Base.similar(A::TSlow, ::Type{T}, dims::Dims) where {T} = TSlow(T, dims)
import Base: IndexCartesian
Base.IndexStyle(::Type{A}) where {A<:TSlow} = IndexCartesian()
# Until #11242 is merged, we need to define each dimension independently
Base.getindex(A::TSlow{T,0}) where {T} = get(A.data, (), zero(T))
Base.getindex(A::TSlow{T,1}, i1::Int) where {T} = get(A.data, (i1,), zero(T))
Base.getindex(A::TSlow{T,2}, i1::Int, i2::Int) where {T} = get(A.data, (i1,i2), zero(T))
Base.getindex(A::TSlow{T,3}, i1::Int, i2::Int, i3::Int) where {T} =
    get(A.data, (i1,i2,i3), zero(T))
Base.getindex(A::TSlow{T,4}, i1::Int, i2::Int, i3::Int, i4::Int) where {T} =
    get(A.data, (i1,i2,i3,i4), zero(T))
Base.getindex(A::TSlow{T,5}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) where {T} =
    get(A.data, (i1,i2,i3,i4,i5), zero(T))

Base.setindex!(A::TSlow{T,0}, v) where {T} = (A.data[()] = v)
Base.setindex!(A::TSlow{T,1}, v, i1::Int) where {T} = (A.data[(i1,)] = v)
Base.setindex!(A::TSlow{T,2}, v, i1::Int, i2::Int) where {T} = (A.data[(i1,i2)] = v)
Base.setindex!(A::TSlow{T,3}, v, i1::Int, i2::Int, i3::Int) where {T} =
    (A.data[(i1,i2,i3)] = v)
Base.setindex!(A::TSlow{T,4}, v, i1::Int, i2::Int, i3::Int, i4::Int) where {T} =
    (A.data[(i1,i2,i3,i4)] = v)
Base.setindex!(A::TSlow{T,5}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) where {T} =
    (A.data[(i1,i2,i3,i4,i5)] = v)

const can_inline = Base.JLOptions().can_inline != 0
function test_scalar_indexing(::Type{T}, shape, ::Type{TestAbstractArray}) where T
    N = prod(shape)
    A = reshape(collect(1:N), shape)
    B = T(A)
    @test A == B
    # Test indexing up to 5 dimensions
    trailing5 = CartesianIndex(ntuple(x->1, max(ndims(B)-5, 0)))
    trailing4 = CartesianIndex(ntuple(x->1, max(ndims(B)-4, 0)))
    trailing3 = CartesianIndex(ntuple(x->1, max(ndims(B)-3, 0)))
    trailing2 = CartesianIndex(ntuple(x->1, max(ndims(B)-2, 0)))
    i=0
    for i5 = 1:size(B, 5)
        for i4 = 1:size(B, 4)
            for i3 = 1:size(B, 3)
                for i2 = 1:size(B, 2)
                    for i1 = 1:size(B, 1)
                        i += 1
                        @test A[i1,i2,i3,i4,i5,trailing5] == B[i1,i2,i3,i4,i5,trailing5] == i
                        @test A[i1,i2,i3,i4,i5,trailing5] ==
                              Base.unsafe_getindex(B, i1, i2, i3, i4, i5, trailing5) == i
                    end
                end
            end
        end
    end
    # Test linear indexing and partial linear indexing
    i=0
    for i1 = 1:length(B)
        i += 1
        @test A[i1] == B[i1] == i
    end
    i=0
    for i2 = 1:size(B, 2)
        for i1 = 1:size(B, 1)
            i += 1
            @test A[i1,i2,trailing2] == B[i1,i2,trailing2] == i
        end
    end
    @test A == B
    i=0
    for i3 = 1:size(B, 3)
        for i2 = 1:size(B, 2)
            for i1 = 1:size(B, 1)
                i += 1
                @test A[i1,i2,i3,trailing3] == B[i1,i2,i3,trailing3] == i
            end
        end
    end
    # Test zero-dimensional accesses
    @test A[1] == B[1] == 1
    # Test multidimensional scalar indexed assignment
    C = T(Int, shape)
    D1 = T(Int, shape)
    D2 = T(Int, shape)
    D3 = T(Int, shape)
    i=0
    for i5 = 1:size(B, 5)
        for i4 = 1:size(B, 4)
            for i3 = 1:size(B, 3)
                for i2 = 1:size(B, 2)
                    for i1 = 1:size(B, 1)
                        i += 1
                        C[i1,i2,i3,i4,i5,trailing5] = i
                        # test general unsafe_setindex!
                        Base.unsafe_setindex!(D1, i, i1,i2,i3,i4,i5,trailing5)
                        # test for dropping trailing dims
                        Base.unsafe_setindex!(D2, i, i1,i2,i3,i4,i5,trailing5, 1, 1, 1)
                        # test for expanding index argument to appropriate dims
                        Base.unsafe_setindex!(D3, i, i1,i2,i3,i4,trailing4)
                    end
                end
            end
        end
    end
    @test D1 == D2 == C == B == A
    @test D3[:, :, :, :, 1, trailing5] == D2[:, :, :, :, 1, trailing5]
    # Test linear indexing and partial linear indexing
    C = T(Int, shape)
    fill!(C, 0)
    @test C != B && C != A
    i=0
    for i1 = 1:length(C)
        i += 1
        C[i1] = i
    end
    @test C == B == A
    C = T(Int, shape)
    i=0
    C2 = reshape(C, Val(2))
    for i2 = 1:size(C2, 2)
        for i1 = 1:size(C2, 1)
            i += 1
            C2[i1,i2,trailing2] = i
        end
    end
    @test C == B == A
    C = T(Int, shape)
    i=0
    C3 = reshape(C, Val(3))
    for i3 = 1:size(C3, 3)
        for i2 = 1:size(C3, 2)
            for i1 = 1:size(C3, 1)
                i += 1
                C3[i1,i2,i3,trailing3] = i
            end
        end
    end
    @test C == B == A
    # Test zero-dimensional setindex
    if length(A) == 1
        A[] = 0; B[] = 0
        @test A[] == B[] == 0
        @test A == B
    else
        # TODO: Re-enable after PLI deprecation
        # @test_throws BoundsError A[] = 0
        # @test_throws BoundsError B[] = 0
        # @test_throws BoundsError A[]
        # @test_throws BoundsError B[]
    end
end

function test_vector_indexing(::Type{T}, shape, ::Type{TestAbstractArray}) where T
    @testset "test_vector_indexing{$(T)}" begin
        N = prod(shape)
        A = reshape(collect(1:N), shape)
        B = T(A)
        trailing5 = CartesianIndex(ntuple(x->1, max(ndims(B)-5, 0)))
        trailing4 = CartesianIndex(ntuple(x->1, max(ndims(B)-4, 0)))
        trailing3 = CartesianIndex(ntuple(x->1, max(ndims(B)-3, 0)))
        trailing2 = CartesianIndex(ntuple(x->1, max(ndims(B)-2, 0)))
        idxs = rand(1:N, 3, 3, 3)
        @test B[idxs] == A[idxs] == idxs
        @test B[vec(idxs)] == A[vec(idxs)] == vec(idxs)
        @test B[:] == A[:] == collect(1:N)
        @test B[1:end] == A[1:end] == collect(1:N)
        @test B[:,:,trailing2] == A[:,:,trailing2] == B[:,:,1,trailing3] == A[:,:,1,trailing3]
            B[1:end,1:end,trailing2] == A[1:end,1:end,trailing2] == B[1:end,1:end,1,trailing3] == A[1:end,1:end,1,trailing3]

        @testset "Test with containers that aren't Int[]" begin
            @test B[[]] == A[[]] == []
            @test B[convert(Array{Any}, idxs)] == A[convert(Array{Any}, idxs)] == idxs
        end

        idx1 = rand(1:size(A, 1), 3)
        idx2 = rand(1:size(A, 2), 4, 5)
        @testset "Test adding dimensions with matrices" begin
            @test B[idx1, idx2, trailing2] == A[idx1, idx2, trailing2] == reshape(A[idx1, vec(idx2), trailing2], 3, 4, 5) == reshape(B[idx1, vec(idx2), trailing2], 3, 4, 5)
            @test B[1, idx2, trailing2] == A[1, idx2, trailing2] == reshape(A[1, vec(idx2), trailing2], 4, 5) == reshape(B[1, vec(idx2), trailing2], 4, 5)
        end
            # test removing dimensions with 0-d arrays
        @testset "test removing dimensions with 0-d arrays" begin
            idx0 = reshape([rand(1:size(A, 1))])
            @test B[idx0, idx2, trailing2] == A[idx0, idx2, trailing2] == reshape(A[idx0[], vec(idx2), trailing2], 4, 5) == reshape(B[idx0[], vec(idx2), trailing2], 4, 5)
            @test B[reshape([end]), reshape([end]), trailing2] == A[reshape([end]), reshape([end]), trailing2] == reshape([A[end,end,trailing2]]) == reshape([B[end,end,trailing2]])
        end

        mask = bitrand(shape)
        @testset "test logical indexing" begin
            @test B[mask] == A[mask] == B[find(mask)] == A[find(mask)] == find(mask)
            @test B[vec(mask)] == A[vec(mask)] == find(mask)
            mask1 = bitrand(size(A, 1))
            mask2 = bitrand(size(A, 2))
            @test B[mask1, mask2, trailing2] == A[mask1, mask2, trailing2] == B[find(mask1), find(mask2), trailing2]
            @test B[mask1, 1, trailing2] == A[mask1, 1, trailing2] == find(mask1)
        end
    end
end

function test_primitives(::Type{T}, shape, ::Type{TestAbstractArray}) where T
    N = prod(shape)
    A = reshape(collect(1:N), shape)
    B = T(A)

    # last(a)
    @test last(B) == B[length(B)]

    # strides(a::AbstractArray)
    @inferred strides(B)
    strides_B = strides(B)
    for (i, _stride) in enumerate(collect(strides_B))
        @test _stride == stride(B, i)
    end

    # isassigned(a::AbstractArray, i::Int...)
    j = rand(1:length(B))
    @test isassigned(B, j) == true
    if T == T24Linear
        @test isassigned(B, length(B) + 1) == false
    end

    # reshape(a::AbstractArray, dims::Dims)
    @test_throws DimensionMismatch reshape(B, (0, 1))

    # copy!(dest::AbstractArray, src::AbstractArray)
    @test_throws BoundsError copy!(Vector{Int}(uninitialized, 10), [1:11...])

    # convert{T, N}(::Type{Array}, A::AbstractArray{T, N})
    X = [1:10...]
    Y = [1 2; 3 4]
    @test convert(Array, X) == X
    @test convert(Array, Y) == Y

    # convert{T}(::Type{Vector}, A::AbstractVector{T})
    @test convert(Vector, X) == X
    @test convert(Vector, view(X, 2:4)) == [2,3,4]
    @test_throws MethodError convert(Vector, Y)

    # convert{T}(::Type{Matrix}, A::AbstractMatrix{T})
    @test convert(Matrix, Y) == Y
    @test convert(Matrix, view(Y, 1:2, 1:2)) == Y
    @test_throws MethodError convert(Matrix, X)
end

mutable struct TestThrowNoGetindex{T} <: AbstractVector{T} end
@testset "ErrorException if getindex is not defined" begin
    Base.length(::TestThrowNoGetindex) = 2
    Base.size(::TestThrowNoGetindex) = (2,)
    @test_throws ErrorException isassigned(TestThrowNoGetindex{Float64}(), 1)
end

function test_in_bounds(::Type{TestAbstractArray})
    n = rand(2:5)
    sz = rand(2:5, n)
    len = prod(sz)
    A = zeros(sz...)
    for i in 1:len
        @test checkbounds(Bool, A, i) == true
    end
    @test checkbounds(Bool, A, len + 1) == false
end

mutable struct UnimplementedFastArray{T, N} <: AbstractArray{T, N} end
Base.IndexStyle(::UnimplementedFastArray) = Base.IndexLinear()

mutable struct UnimplementedSlowArray{T, N} <: AbstractArray{T, N} end
Base.IndexStyle(::UnimplementedSlowArray) = Base.IndexCartesian()

mutable struct UnimplementedArray{T, N} <: AbstractArray{T, N} end

function test_getindex_internals(::Type{T}, shape, ::Type{TestAbstractArray}) where T
    N = prod(shape)
    A = reshape(collect(1:N), shape)
    B = T(A)

    @test getindex(A, 1) == 1
    @test getindex(B, 1) == 1
    @test Base.unsafe_getindex(A, 1) == 1
    @test Base.unsafe_getindex(B, 1) == 1
end

function test_getindex_internals(::Type{TestAbstractArray})
    U = UnimplementedFastArray{Int, 2}()
    V = UnimplementedSlowArray{Int, 2}()
    @test_throws ErrorException getindex(U, 1)
    @test_throws ErrorException Base.unsafe_getindex(U, 1)
    @test_throws ErrorException getindex(V, 1, 1)
    @test_throws ErrorException Base.unsafe_getindex(V, 1, 1)
end

function test_setindex!_internals(::Type{T}, shape, ::Type{TestAbstractArray}) where T
    N = prod(shape)
    A = reshape(collect(1:N), shape)
    B = T(A)

    Base.unsafe_setindex!(B, 2, 1)
    @test B[1] == 2
end

function test_setindex!_internals(::Type{TestAbstractArray})
    U = UnimplementedFastArray{Int, 2}()
    V = UnimplementedSlowArray{Int, 2}()
    @test_throws ErrorException setindex!(U, 0, 1)
    @test_throws ErrorException Base.unsafe_setindex!(U, 0, 1)
    @test_throws ErrorException setindex!(V, 0, 1, 1)
    @test_throws ErrorException Base.unsafe_setindex!(V, 0, 1, 1)
end

function test_get(::Type{TestAbstractArray})
    A = T24Linear([1:24...])
    B = TSlow([1:24...])

    @test get(A, (), 0) == Int[]
    @test get(B, (), 0) == TSlow(Int, 0)
end

function test_cat(::Type{TestAbstractArray})
    A = T24Linear([1:24...])
    b_int = reshape([1:27...], 3, 3, 3)
    b_float = reshape(Float64[1:27...], 3, 3, 3)
    b2hcat = Array{Float64}(uninitialized, 3, 6, 3)
    b1 = reshape([1:9...], 3, 3)
    b2 = reshape([10:18...], 3, 3)
    b3 = reshape([19:27...], 3, 3)
    b2hcat[:, :, 1] = hcat(b1, b1)
    b2hcat[:, :, 2] = hcat(b2, b2)
    b2hcat[:, :, 3] = hcat(b3, b3)
    b3hcat = Array{Float64}(uninitialized, 3, 9, 3)
    b3hcat[:, :, 1] = hcat(b1, b1, b1)
    b3hcat[:, :, 2] = hcat(b2, b2, b2)
    b3hcat[:, :, 3] = hcat(b3, b3, b3)
    B = TSlow(b_int)
    B1 = TSlow([1:24...])
    B2 = TSlow([1:25...])
    C1 = TSlow([1 2; 3 4])
    C2 = TSlow([1 2 3; 4 5 6])
    C3 = TSlow([1 2; 3 4; 5 6])
    D = [1:24...]
    i = rand(1:10)

    @test cat(i) == Any[]
    @test vcat() == Any[]
    @test hcat() == Any[]
    @test hcat(1, 1.0, 3, 3.0) == [1.0 1.0 3.0 3.0]
    @test_throws ArgumentError hcat(B1, B2)
    @test_throws ArgumentError vcat(C1, C2)

    @test vcat(B) == B
    @test hcat(B) == B
    @test Base.typed_hcat(Float64, B) == TSlow(b_float)
    @test Base.typed_hcat(Float64, B, B) == TSlow(b2hcat)
    @test Base.typed_hcat(Float64, B, B, B) == TSlow(b3hcat)

    @test vcat(B1, B2) == TSlow(vcat([1:24...], [1:25...]))
    @test hcat(C1, C2) == TSlow([1 2 1 2 3; 3 4 4 5 6])
    @test hcat(C1, C2, C1) == TSlow([1 2 1 2 3 1 2; 3 4 4 5 6 3 4])

    # hvcat
    for nbc in (1, 2, 3, 4, 5, 6)
        @test hvcat(nbc, 1:120...) ==
              transpose(reshape([1:120...], nbc, round(Int, 120 / nbc)))
    end

    @test_throws ArgumentError hvcat(7, 1:20...)
    @test_throws ArgumentError hvcat((2), C1, C3)
    @test_throws ArgumentError hvcat((1), C1, C2)
    @test_throws ArgumentError hvcat((1), C2, C3)

    tup = tuple(rand(1:10, i)...)
    @test hvcat(tup) == []

    # check for shape mismatch
    @test_throws ArgumentError hvcat((2, 2), 1, 2, 3, 4, 5)
    @test_throws ArgumentError Base.typed_hvcat(Int, (2, 2), 1, 2, 3, 4, 5)
    # check for # of columns mismatch b/w rows
    @test_throws ArgumentError hvcat((3, 2), 1, 2, 3, 4, 5, 6)
    @test_throws ArgumentError Base.typed_hvcat(Int, (3, 2), 1, 2, 3, 4, 5, 6)

    # 18395
    @test isa(Any["a" 5; 2//3 1.0][2,1], Rational{Int})

    # 13665, 19038
    @test @inferred(hcat([1.0 2.0], 3))::Array{Float64,2} == [1.0 2.0 3.0]
    @test @inferred(vcat([1.0, 2.0], 3))::Array{Float64,1} == [1.0, 2.0, 3.0]

    @test @inferred(vcat(["a"], "b"))::Vector{String} == ["a", "b"]
    @test @inferred(vcat((1,), (2.0,)))::Vector{Tuple{Real}} == [(1,), (2.0,)]
end

function test_ind2sub(::Type{TestAbstractArray})
    n = rand(2:5)
    dims = tuple(rand(1:5, n)...)
    len = prod(dims)
    A = reshape(collect(1:len), dims...)
    I = ind2sub(dims, [1:len...])
    for i in 1:len
        idx = [ I[j][i] for j in 1:n ]
        @test A[idx...] == A[i]
    end
end

# A custom linear slow array that insists upon Cartesian indexing
mutable struct TSlowNIndexes{T,N} <: AbstractArray{T,N}
    data::Array{T,N}
end
Base.IndexStyle(::Type{A}) where {A<:TSlowNIndexes} = Base.IndexCartesian()
Base.size(A::TSlowNIndexes) = size(A.data)
Base.getindex(A::TSlowNIndexes, index::Int...) = error("Must use $(ndims(A)) indexes")
Base.getindex(A::TSlowNIndexes{T,2}, i::Int, j::Int) where {T} = A.data[i,j]


@testset "issue #15689, mapping an abstract type" begin
    @test isa(map(Set, Array[[1,2],[3,4]]), Vector{Set{Int}})
end

@testset "mapping over scalars and empty arguments:" begin
    @test map(sin, 1) === sin(1)
    @test map(()->1234) === 1234
end

function test_UInt_indexing(::Type{TestAbstractArray})
    A = [1:100...]
    _A = Expr(:quote, A)
    for i in 1:100
        _i8 = convert(UInt8, i)
        _i16 = convert(UInt16, i)
        _i32 = convert(UInt32, i)
        for _i in (_i8, _i16, _i32)
            @eval begin
                @test $_A[$_i] == $i
            end
        end
    end
end

# Issue 13315
function test_13315(::Type{TestAbstractArray})
    U = UInt(1):UInt(2)
    @test [U;[U;]] == [UInt(1), UInt(2), UInt(1), UInt(2)]
end

# checksquare
function test_checksquare()
    @test LinAlg.checksquare(zeros(2,2)) == 2
    @test LinAlg.checksquare(zeros(2,2),zeros(3,3)) == [2,3]
    @test_throws DimensionMismatch LinAlg.checksquare(zeros(2,3))
end

#----- run tests -------------------------------------------------------------#

@testset for T in (T24Linear, TSlow), shape in ((24,), (2, 12), (2,3,4), (1,2,3,4), (4,3,2,1))
    test_scalar_indexing(T, shape, TestAbstractArray)
    test_vector_indexing(T, shape, TestAbstractArray)
    test_primitives(T, shape, TestAbstractArray)
    test_getindex_internals(T, shape, TestAbstractArray)
    test_setindex!_internals(T, shape, TestAbstractArray)
end
test_in_bounds(TestAbstractArray)
test_getindex_internals(TestAbstractArray)
test_setindex!_internals(TestAbstractArray)
test_get(TestAbstractArray)
test_cat(TestAbstractArray)
test_ind2sub(TestAbstractArray)

include("generic_map_tests.jl")
generic_map_tests(map, map!)

test_UInt_indexing(TestAbstractArray)
test_13315(TestAbstractArray)
test_checksquare()

A = TSlowNIndexes(rand(2,2))
@test_throws ErrorException A[1]
@test A[1,1] == A.data[1]
@test first(A) == A.data[1]

@testset "#16381" begin
    @inferred size(rand(3,2,1), 2, 1)
    @inferred size(rand(3,2,1), 2, 1, 3)

    @test @inferred(indices(rand(3,2)))    == (1:3,1:2)
    @test @inferred(indices(rand(3,2,1)))  == (1:3,1:2,1:1)
    @test @inferred(indices(rand(3,2), 1)) == 1:3
    @test @inferred(indices(rand(3,2), 2)) == 1:2
    @test @inferred(indices(rand(3,2), 3)) == 1:1
end

@testset "#17088" begin
    n = 10
    M = rand(n, n)
    @testset "vector of vectors" begin
        v = [[M]; [M]] # using vcat
        @test size(v) == (2,)
        @test !issparse(v)
    end
    @testset "matrix of vectors" begin
        m1 = [[M] [M]] # using hcat
        m2 = [[M] [M];] # using hvcat
        @test m1 == m2
        @test size(m1) == (1,2)
        @test !issparse(m1)
        @test !issparse(m2)
    end
end

@testset "isinteger and isreal" begin
    @test all(isinteger, Diagonal(rand(1:5,5)))
    @test isreal(Diagonal(rand(5)))
end

@testset "unary ops" begin
    let A = Diagonal(rand(1:5,5))
        @test +(A) == A
        @test *(A) == A
    end
end

@testset "flipdim on empty" begin
    @test flipdim(Diagonal([]),1) == Diagonal([])
end

@testset "ndims and friends" begin
    @test ndims(Diagonal(rand(1:5,5))) == 2
    @test ndims(Diagonal{Float64}) == 2
    @test Base.elsize(Diagonal(rand(1:5,5))) == sizeof(Int)
end

@testset "Issue #17811" begin
    A17811 = Integer[]
    I = [abs(x) for x in A17811]
    @test isa(I, Array{Any,1})
    push!(I, 1)
    @test I == Any[1]
    @test isa(map(abs, A17811), Array{Any,1})
end

@testset "copymutable for itrs" begin
    @test Base.copymutable((1,2,3)) == [1,2,3]
end

@testset "sub2ind for empty tuple" begin
    @test sub2ind(()) == 1
end

@testset "to_shape" begin
    @test Base.to_shape(()) === ()
    @test Base.to_shape(1) === 1
end

@testset "issue #19267" begin
    @test ndims((1:3)[:]) == 1
    @test ndims((1:3)[:,:]) == 2
    @test ndims((1:3)[:,[1],:]) == 3
    @test ndims((1:3)[:,[1],:,[1]]) == 4
    @test ndims((1:3)[:,[1],1:1,:]) == 4
    @test ndims((1:3)[:,:,1:1,:]) == 4
    @test ndims((1:3)[:,:,1:1]) == 3
    @test ndims((1:3)[:,:,1:1,:,:,[1]]) == 6
end

@testset "dispatch loop introduced in #19305" begin
    @test [(1:2) zeros(2,2); ones(3,3)] == [[1,2] zeros(2,2); ones(3,3)] == [reshape([1,2],2,1) zeros(2,2); ones(3,3)]
end

@testset "checkbounds_indices method ambiguities #20989" begin
    @test Base.checkbounds_indices(Bool, (1:1,), ([CartesianIndex(1)],))
end

# keys, values, pairs
for A in (rand(2), rand(2,3))
    local A
    for (i, v) in pairs(A)
        @test A[i] == v
    end
    @test collect(values(A)) == collect(A)
end

# nextind
@test nextind(zeros(4), 2) == 3
@test nextind(zeros(2,3), CartesianIndex(2,1)) == CartesianIndex(1, 2)

@testset "ImageCore #40" begin
    Base.convert(::Type{Array{T,n}}, a::Array{T,n}) where {T<:Number,n} = a
    Base.convert(::Type{Array{T,n}}, a::Array) where {T<:Number,n} =
        copy!(Array{T,n}(uninitialized, size(a)), a)
    @test isa(empty(Dict(:a=>1, :b=>2.0), Union{}, Union{}), Dict{Union{}, Union{}})
end

@testset "zero-dimensional copy" begin
    Z = Array{Int,0}(uninitialized); Z[] = 17
    @test Z == collect(Z) == copy(Z)
end

@testset "empty" begin
    @test isempty([])
    v = [1, 2, 3]
    v2 = empty(v)
    v3 = empty(v, Float64)
    @test !isempty(v)
    empty!(v)
    @test isempty(v)
    @test isempty(v2::Vector{Int})
    @test isempty(v3::Vector{Float64})
end

### HssMatrices.jl module
# A simple Julia package that allows working with HSS matrices
# The package aims to be simple, intuitive and efficient
# Written by Boris Bonev, Nov. 2020
__precompile__()
module HssMatrices

  # dependencies, trying to keep this list to a minimum if possible
  using LinearAlgebra
  using SparseArrays # introduce custom constructors from sparse matrices
  using AbstractTrees
  using Plots # in the future, move to RecipesBase instead

  # load BLAS/LAPACK routines only used within the library# load efficient BLAS and LAPACK routines for factorizations
  import LinearAlgebra.LAPACK.geqlf!
  import LinearAlgebra.LAPACK.gelqf!
  import LinearAlgebra.LAPACK.ormql!
  import LinearAlgebra.LAPACK.ormlq!
  import LinearAlgebra.BLAS.ger!
  import LinearAlgebra.BLAS.trsm
  import LinearAlgebra.ishermitian

  # using InvertedIndices, DataStructures
  import Base.+, Base.-, Base.*, Base.\, Base.Matrix, Base.copy, Base.size, Base.show, Base.eltype
  # more Base overrides - these still need to be added to HSS matrices!
  import Base./, Base.convert, Base.^, Base.getindex, Base.adjoint
  import LinearAlgebra.ldiv!, LinearAlgebra.mul!

  # change this rtol, atol and modify the code to check for the one that is bigger
  # const atol = 0
  # const rtol = 1e-9
  #const tol = 1e-9 
  #const reltol = true
  #const leafsize = 64

  #export tol, reltol, leafsize
  # HssMatrices.jl
  export HssOptions
  # hssmatrix.jl
  export HssLeaf, HssNode, HssMatrix, isleaf, isbranch, hssrank, full, checkdims, prune_leaves!
  # prrqr.jl
  export prrqr, prrqr!
  # binarytree.jl
  export BinaryNode, leftchild, rightchild, isleaf, isbranch, depth
  # clustertree.jl
  export bisection_cluster, cluster
  # linearoperator.jl
  export AbstractLinearOperator, AbstractMatOrLinOp, LinearOperator, HermitianLinearOperator
  # compression.jl
  export compress, randcompress, randcompress_adaptive, recompress!
  # generators.jl  
  export generators, orthonormalize_generators!
  # matmul.jl
  # ulvfactor.jl
  export ulvfactsolve
  # hssdivide.jl
  export ldiv!, _ulvfactor_leaves!
  # constructors.jl
  export lowrank2hss
  # visualization.jl
  export plotranks, pcolor

  mutable struct HssOptions
    atol::Float64
    rtol::Float64
    leafsize::Int
    noversampling::Int
    stepsize::Int
    recompress::Bool
    verbose::Bool
  end
  
  # set default values
  function HssOptions(::Type{T}; args...) where T
    opts = HssOptions(
      1e6,                # atol # by default turned off
      1e-9,               # rtol
      64,                 # leafsize
      10,                 # noversampling
      20,                 # stepsize
      true,               # recompress
      true,               # verbose
    )
    for (key, value) in args
      setfield!(opts, key, value)
    end
    opts
  end
  HssOptions(; args...) = HssOptions(Float64; args...)
  
  function copy(opts::HssOptions; args...)
    opts_ = HssOptions()
    for field in fieldnames(typeof(opts))
      setfield!(opts_, field, getfield(opts, field))
    end
    for (key, value) in args
      setfield!(opts_, key, value)
    end
    opts_
  end
  
  function chkopts!(opts::HssOptions)
    opts.atol > 0 || throw(ArgumentError("atol"))
    opts.rtol > 0 || throw(ArgumentError("rtol"))
    opts.leafsize >= 1 || throw(ArgumentError("leafsize"))
    opts.stepsize >= 1 || throw(ArgumentError("stepsize"))
    opts.noversampling >= 1 || throw(ArgumentError("noversampling"))
  end

  include("hssmatrix.jl")
  include("prrqr.jl")
  include("binarytree.jl")
  include("clustertree.jl")
  include("linearoperator.jl")
  include("compression.jl")
  include("generators.jl")
  include("matmul.jl")
  include("ulvfactor.jl")
  include("hssdivide.jl")
  include("constructors.jl")
  include("visualization.jl")
end

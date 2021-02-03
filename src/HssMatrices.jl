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
  using DataStructures
  #using RecipesBase
  using Plots # in the future, move to RecipesBase

  # using InvertedIndices, DataStructures
  import Base.*, Base.+, Base.Matrix, Base.copy, Base.size

  global tol = 1e-9
  global reltol = true
  global leafsize = 32

  #export tol, reltol, leafsize
  # hss_matrix.jl
  export HssLeaf, HssNode, HssMatrix, isleaf, isbranch, hssrank
  # prrqr.jl
  export prrqr!, truncate_block!
  # binarytree.jl and clustertree.jl
  export BinaryNode, leftchild, rightchild, isleaf, isbranch, bisection_cluster
  # basicops.jl
  export full, prune_leaves!
  # compression.jl
  export hss_compress_direct, hss_recompress!
  # generators.jl  
  export generators, orthonormalize_generators!
  # matmul.jl
  # ulvfactor.jl
  export ulvfactsolve
  # visualization.jl
  export plotranks, pcolor

  include("hssmatrix.jl")
  include("prrqr.jl")
  include("binarytree.jl")
  include("clustertree.jl")
  include("basicops.jl")
  include("compression.jl")
  include("generators.jl")
  include("matmul.jl")
  include("ulvfactor.jl")
  include("visualization.jl")
end

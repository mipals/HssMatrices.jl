include("../src/HssMatrices.jl")
using .HssMatrices
using LinearAlgebra
using BenchmarkTools

### run benchmarks on Cauchy matrix
K(x,y) = (x-y) != 0 ? 1/(x-y) : 10000.
A = [ K(x,y) for x=-1:0.001:1, y=-1:0.001:1];
b = randn(size(A,2), 5);

# test the simple implementation of cluster trees
m, n = size(A)
#lsz = 64;
lsz = 64;
rcl = bisection_cluster(1:m, lsz)
ccl = bisection_cluster(1:n, lsz)

hssA = compress(A, rcl, ccl);

# time compression
println("Benchmarking compression...")
@btime hssA = compress(A, rcl, ccl);

# time compression
println("Benchmarking randomized compression...")
@btime hssA = randcompress_adaptive(A, rcl, ccl);

println("Benchmarking re-compression...")
hssB = copy(hssA)
@btime hssA = recompress!(hssB; rtol=1e-3);

# time matvec
println("Benchmarking matvec...")
x = randn(size(A,2), 10);
@btime y = hssA*x

# time ulvfactsolve
println("Benchmarking ulvfactsolve...")
b = randn(size(A,2), 10);
@btime x = ulvfactsolve(hssA, b);

# time hssldivide
println("Benchmarking hssldivide...")
hssX = compress(1.0*Matrix(I, n, n), ccl, ccl, atol=1e9, rtol=1e9) # this should probably be one constructor
@btime hssC = ldiv!(copy(hssA), hssX)
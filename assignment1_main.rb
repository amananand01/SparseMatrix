=begin

ECE 421 Winter 2019 Group 2

Adit Hasan (adit)
Anand Aman (aanand)
Yuqiao Wen (yuqiao)
Zhihao Zhang (zhihao9)

=end

require_relative 'SparseMatrixLibrary/matrix_factory.rb'

matrixFactory = TridiagonalMatrixFactory.new

# Create a 3x4 TridiagonalSparseMatrix with all zeros
puts "3x4 Zeros"
zeros = matrixFactory.CreateZeroes(3, 4)
print zeros.to2DArray()

puts ""

# Create a 5x5 TridiagonalSparseMatrix with just ones
puts "5x5 ones"
ones = matrixFactory.CreateOnes(5, 5)
print ones.to2DArray()

puts ""

# Create a 4x4 TridiagonalSparseMatrix that is an identity matrix
puts "4x4 identity"
identity = matrixFactory.CreateIdentity(4)
print identity.to2DArray()

puts ""

# Create a 5x5 tri-diagonal matrix
puts "5x5 tri-diagonal matrix"
triMatrix = matrixFactory.Create([5,1,0,0,0], [1,4,2,0,0], [0,2,3,4,0], [0,0,4,2,3], [0,0,0,3,1])
print triMatrix.to2DArray()

puts ""

puts "Inverting the tri-diaognal matrix"
print triMatrix.inverse()
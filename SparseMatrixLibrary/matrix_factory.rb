require_relative './sparse_matrix.rb'

module AbstractSparseMatrixFactory

    def CreateIdentity(size)
        raise NotImplementedError, "CreateIdentity(size) has not been implemented!"
    end

    def CreateZeroes(numRows, numColumns)
        raise NotImplementedError, "CreateZeroes(numRows, numColumns) has not been implemented!"
    end

    def CreateOnes(numRows, numColumns)
        raise NotImplementedError, "CreateOnes(numRows, numColumns) has not been implemented!"
    end

    def Create(*params)
        raise NotImplementedError, "Create(*params) has not been implemented!"
    end
end

class YaleSparseMatrixFactory
  include AbstractSparseMatrixFactory, SparseMatrix, Test::Unit::Assertions
  def CreateIdentity(size)
    assert(size > 0)
    SparseMatrix::YaleSparseMatrix.new(NMatrix.eye([size, size], dtype: :int32, stype: :yale, default: 0))
  end

  def CreateZeroes(numRows, numColumns)
    assert(numRows > 0)
    assert(numColumns > 0)
    SparseMatrix::YaleSparseMatrix.new(NMatrix.zeros([numRows, numColumns], dtype: :int32, stype: :yale, default: 0))
  end

  def CreateOnes(numRows, numColumns)
    assert(numRows > 0)
    assert(numColumns > 0)
    SparseMatrix::YaleSparseMatrix.new(NMatrix.ones([numRows, numColumns], dtype: :int32, stype: :yale, default: 0))
  end

  def Create(*params)
    numRows = params.length
    assert(numRows > 0)
    numColumns = params[0].length
    assert(numColumns > 0)
    for i in 0...numRows
      assert(params[i].length == numColumns)
    end
    SparseMatrix::YaleSparseMatrix.new(N[*params << {stype: :yale, dtype: :int32, default: 0}])
  end
end

class TridiagonalMatrixFactory
  include AbstractSparseMatrixFactory, SparseMatrix, Test::Unit::Assertions
    
    def CreateIdentity(size)
        inputMatrix = Array.new(size) {Array.new(size, 0)}

        for i in 0...size
            for j in 0...size
                if i == j
                    inputMatrix[i][j] = 1
                end
            end
        end

        raise "Error Occured: Non-tridiagonal matrix generated" unless IsTridiagonal?(inputMatrix)
        return SparseMatrix::TridiagonalSparseMatrix.new(inputMatrix, size, size)
    end

    def CreateZeroes(numRows, numColumns)
        inputMatrix = Array.new(numRows) {Array.new(numColumns, 0)}

        raise "Error Occured: Non-tridiagonal matrix generated" unless IsTridiagonal?(inputMatrix)
        return SparseMatrix::TridiagonalSparseMatrix.new(inputMatrix, numRows, numColumns)
    end

    def CreateOnes(numRows, numColumns)
        # Creates a tri-diagonal matrix with only 1s for non-zero values
        inputMatrix = Array.new(numRows) {Array.new(numColumns, 0)}

        for i in 0...numRows
            for j in 0...numColumns
                if i==j or i==j-1 or i==j+1
                    inputMatrix[i][j] = 1
                end
            end
        end

        raise "Error Occured: Non-tridiagonal matrix generated" unless IsTridiagonal?(inputMatrix)
        return SparseMatrix::TridiagonalSparseMatrix.new(inputMatrix, numRows, numColumns)
    end

    def Create(*params)
        inputMatrix = params
        numRows = params.length
        numColumns = params[0].length

        raise "Error Occured: Attempting to pass in non-tri-diagonal matrix" unless IsTridiagonal?(inputMatrix)
        return SparseMatrix::TridiagonalSparseMatrix.new(inputMatrix, numRows, numColumns)
    end

    private
    # This is a check for validity
    def IsTridiagonal?(matrixarray)
        # Pre : 
        assert(old = matrixarray.clone)

        # Check for validity
        for i in 0...matrixarray.length
            for j in 0...matrixarray[0].length
                if i!=j and i!=j-1 and i!=j+1 and matrixarray[i][j] != 0 # non-zero value in position outside of 3 diagonals
                    return false
                end
            end
        end

        # Post :
        assert(old == matrixarray)
        return true
    end
end

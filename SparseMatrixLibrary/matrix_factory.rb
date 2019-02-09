require './sparse_matrix.rb'

module AbstractSparseMatrixFactory

    def self.create(classname, matrixarray)
        raise NotImplementedError, "self.create(classname, matrixarray) has not been implemented!"
    end

    # This is for specialized square matrices e.g. Identity, Zero etc
    def self.create(classname, size)
        raise NotImplementedError, "self.create(classname, size) has not been implemented!"
    end
end

# The factories take care of creating the right shape object and passing it in

class YaleSparseMatrixFactory include AbstractSparseMatrixFactory, SparseMatrix, Test::Unit::Assertions
  def CreateIdentity(numRows, numColumns)
    assert(numRows > 0)
    assert(numColumns > 0)
    assert(numRows == numColumns)
    SparseMatrix::YaleSparseMatrix.new(NMatrix.eye([numRows, numColumns], dtype: :int32, stype: :yale, default: 0))
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

class TridiagonalMatrixFactory include AbstractSparseMatrixFactory
    def self.create(classname, matrixarray)
        # this is for matrices like tri-diagonal matrices
        CheckTridiagonality(matrixarray)
        classname.new(matrixarray)
    end

    def CreateIdentity(size)
        # Pre : 
        assert(size > 0, "Must have positive size value!")
    end

    # This is a check for validity
    def CheckTridiagonality(matrixarray)
        # Pre : 
        assert(old = self.clone)

        # Check for validity

        # Post :
        assert(old == self)
    end
end

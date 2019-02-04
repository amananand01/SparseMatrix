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

class SparseMatrixFactory include AbstractSparseMatrixFactory
    def self.create(classname, matrixarray)
        # check for size and data types in the array
        classname.new(matrixarray)
    end

    def self.create(classname, size)
        raise NotImplementedError, "CreateSparseMatrix(classname, size) for SparseMatrixFactory has not been implemented!"
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

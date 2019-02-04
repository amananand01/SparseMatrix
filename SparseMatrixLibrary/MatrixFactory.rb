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

class SquareMatrixFactory include AbstractSparseMatrixFactory
    def self.create(classname, matrixarray)
        # this is for matrices like tri-diagonal matrices
        classname.new(matrixarray)
    end

    def self.create(classname, size)
        # This is for square matrices with computable contents e.g Identity, Zero etc
        classname.new(size)
    end
end

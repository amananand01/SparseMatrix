require 'test/unit'

module SparseMatrix

  class Shape
    attr_accessor :m
    attr_accessor :n
    def initialize(m, n)
      @m = m
      @n = n
    end
  end

  class AbstractMatrix

    def [](m, n)
      raise NotImplementedError
    end

    def []=(m, n, v)
      raise NotImplementedError
    end

    def transpose()
      raise NotImplementedError
    end

    def add(other)
      raise NotImplementedError
    end

    def subtract(other)
      raise NotImplementedError
    end

    def multiply(other)
      raise NotImplementedError
    end

    def determinant()
      raise NotImplementedError
    end

    def inverse()
      raise NotImplementedError
    end

  end

  class YaleSparseMatrix < AbstractMatrix
    attr_accessor :shape
    def initialize(shape)
      @shape = shape
    end

  end

  class TridiagonalSparseMatrix < AbstractMatrix
    attr_accessor :shape
    def initialize(shape)
      @shape = shape
    end

  end

end

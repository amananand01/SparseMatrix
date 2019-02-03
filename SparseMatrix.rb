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

  class YaleSparseMatrix
    attr_accessor :shape
    def initialize(shape)
      @shape = shape
    end

  end

  class TridiagonalSparseMatrix
    attr_accessor :shape
    def initialize(shape)
      @shape = shape
    end

  end

end

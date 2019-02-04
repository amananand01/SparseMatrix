require 'test/unit'

module SparseMatrix

  include Test::Unit::Assertions

  class Shape
    attr_accessor :m
    attr_accessor :n
    def initialize(m, n)
      # Pre:
      assert(m > 0 && n > 0, "Negative shapes are not allowed.")

      @m = m
      @n = n

      # Post:
      assert(self.m == m && self.n == n)
    end

    def ==(other)
      # Pre:
      assert(other.is_a?(Shape))
    end
  end

  class SquareShape < Shape
    attr_accessor :m

    def initialize(m)
      # Pre;
      assert(m >0, "Negative Shapes are not allowed.")

      @m = m

      # Post:
      assert(self.m == m)
    end

    def ==(other)
      assert(other.is_a?(Shape))
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

    def [](m, n)
      # Pre:
      assert(0 <= m < @shape.m)
      assert(0 <= n < @shape.n)
    end

    def []=(m, n, v)
      # Pre:
      assert(0 <= m < @shape.m)
      assert(0 <= n < @shape.n)

      # Post:
      assert(self[m,n] == v)
    end

    def transpose()
      # Pre:
      old = self.clone
      
      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(old[i,j] == self[j,i])
        end
      end
    end

    def add(other)
      # Pre:
      assert(other.is_a?(AbstractMatrix))
      assert(other.shape == @shape)
      assert(old = self.clone)

      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(self[i,j] == old[i,j] + other[i,j])
        end
      end
    end

    def subtract(other)
      # Pre:
      assert(other.is_a?(AbstractMatrix))
      assert(other.shape == @shape)
      assert(old = self.clone)

      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(self[i,j] == old[i,j] - other[i,j])
        end
      end
    end

    def multiply(other)
    end

    def determinant()
    end

    def inverse()
    end

  end

  class SquareMatrix < AbstractMatrix
    attr_accessor :shape

    def initialize(shape)
      # Pre: 
      assert(shape.is_a?(SquareShape), "Must pass in a square shape to Square Matrix")
      @shape = shape
    end 

    def [](m, n)
      # Pre:
      assert(0 <= m < @shape.m)
      assert(0 <= n < @shape.m)
    end

    def []=(m, n, v)
      # Pre:
      assert(0 <= m < @shape.m)
      assert(0 <= n < @shape.m)

      # Post:
      assert(self[m,n] == v)
    end

    def add(other)
      # Pre:
      assert(other.is_a?(SquareMatrix))
      assert(other.shape == @shape)
      assert(old = self.clone)

      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(self[i,j] == old[i,j] + other[i,j])
        end
      end
    end

    def subtract(other)
      # Pre:
      assert(other.is_a?(AbstractMatrix))
      assert(other.shape == @shape)
      assert(old = self.clone)

      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(self[i,j] == old[i,j] - other[i,j])
        end
      end
    end

    def transpose()
      # Pre:
      assert(old = self.clone)
      
      # Post:
      for i in old.shape.m
        for j in old.shape.n
          assert(old[i,j] == self[j,i])
        end
      end
    end

    def multiply(other)
      # Pre: 
      assert(other.n == @shape.m)
    end

    def determinant()
    end

    def inverse()
      
    end
  end

  class TridiagonalSparseMatrix < SquareMatrix
    attr_accessor :shape
    def initialize(shape)
      super(shape)
    end

    # We will override certain operations with faster versions
    # for Tridiagonal matrices here

    def multiply(other)
    end

    def determinant()
    end

    def inverse()
    end

  end

  class IdentityMatrix < AbstractMatrix
    attr_accessor :shape

    def initialize(shape)
      # Pre: 
      assert(shape.is_a?(SquareShape), "Must pass in a square shape to Identity Matrix")
      @shape = shape
    end 

    def transpose()
      # Pre:
      assert(old = self.clone)
      
      # Post:
      assert(old == self)
    end

    def multiply(other)
      # Pre: 
      assert(other.n == @shape.m)

      # Post: 
      assert(self == other)
    end

    def determinant()
    end

    def inverse()
      # Pre: 
      assert(old = self.clone)
      # Post:
      assert(self == old)
    end
  end

end

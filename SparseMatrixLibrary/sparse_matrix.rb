require 'test/unit'

module SparseMatrix

  include Test::Unit::Assertions

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
    attr_accessor :numRows, :numColumns
    def initialize(numRows, numColumns)
      @numColumns = numColumns
      @numRows = numRows
    end

    def [](m, n)
      # Pre:
      assert(0 <= m < @numRows)
      assert(0 <= n < @numColumns)
    end

    def []=(m, n, v)
      # Pre:
      assert(0 <= m < @numRows)
      assert(0 <= n < @numColumns)

      # Post:
      assert(self[m,n] == v)
    end

    def transpose()
      # Pre:
      old = self.clone

      # Post:
      for i in old.numColumns
        for j in old.numRows
          assert(old[i,j] == self[j,i])
        end
      end
    end

    def add(other)
      # Pre:
      assert(other.is_a?(AbstractMatrix))
      assert(other.numColumns == @numColumns)
      assert(other.numRows == @numRows)
      assert(old = self.clone)

      # Post:
      for i in old.numColumns
        for j in old.numRows
          assert(self[i,j] == old[i,j] + other[i,j])
        end
      end
    end

    def subtract(other)
      # Pre:
      assert(other.is_a?(AbstractMatrix))
      assert(other.numColumns == @numColumns)
      assert(other.numRows == @numRows)
      assert(old = self.clone)

      # Post:
      for i in old.numColumns
      for j in old.numRows
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

  class TridiagonalSparseMatrix < AbstractMatrix
    # attr_accessor :shape

    attr_reader :main_diagonal
    attr_reader :lower_diagonal
    attr_reader :upper_diagonal


    def initialize(matrix)
      # # Pre:
      # assert(shape.is_a?(SquareShape), "Must pass in a square shape to Square Matrix")
      # @shape = shape


      # first  vector => main  diagonal
      # second vector => first diagonal below main
      # third  vector => first diagonal above main
      @main_diagonal  = Array.new
      @lower_diagonal = Array.new
      @upper_diagonal  = Array.new

      for i in 0...matrix.size
        for j in 0...matrix[i].size

          if i==j   then @main_diagonal.push(matrix[i][j])  end
          if i==j+1 then @lower_diagonal.push(matrix[i][j]) end
          if i==j-1 then @upper_diagonal.push(matrix[i][j])  end

        end
      end

    end

    # getting the value
    def [](m, n)
      # Pre:
      # assert(0 <= m < @shape.m)
      # assert(0 <= n < @shape.m)
      #
      begin
        raise "Indices of matrix must be >= 0" unless (m>=0) and (n>=0)
      end

      # index out of bound error
      if m >= main_diagonal.size or n>=main_diagonal.size
        raise "Index out of bound error"
      end

      # return 0 as indices not in the diagonals
      if m!=n and m!=n-1 and m!=n+1
        return 0
      end

      # return from the main diagonal
      if m==n and m < main_diagonal.size
        main_diagonal[m]

      # return from the first diagonal below main diagonal
      elsif m==n+1 and m - 1 < lower_diagonal.size
        lower_diagonal[m-1]

      # return from the first diagonal above main diagonal
      elsif m==n-1 and m < upper_diagonal.size
         upper_diagonal[m]

      else
        raise("Error")
      end

    end


    # setting the value
    def []=(m, n, v)
      # Pre:
      # assert(0 <= m < @shape.m)
      # assert(0 <= n < @shape.m)

      # Post:
      # assert(self[m,n] == v)
    end

    def add(other)
      # Pre:
      # assert(other.is_a?(SquareMatrix))
      # assert(other.shape == @shape)
      # assert(old = self.clone)

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] + other.main_diagonal[i]
      end

      for i in 0...@lower_diagonal.size
        @lower_diagonal[i] = @lower_diagonal[i] + other.lower_diagonal[i]
      end

      for i in 0...@upper_diagonal.size
        @upper_diagonal[i] = @upper_diagonal[i] + other.upper_diagonal[i]
      end

      # TODO: delete it
      p @main_diagonal
      p @lower_diagonal
      p @upper_diagonal

      # Post:
      # for i in old.shape.m
      #   for j in old.shape.n
      #     assert(self[i,j] == old[i,j] + other[i,j])
      #   end
      # end
    end

    def subtract(other)
      # Pre:
      # assert(other.is_a?(AbstractMatrix))
      # assert(other.shape == @shape)
      # assert(old = self.clone)

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] - other.main_diagonal[i]
      end

      for i in 0...@lower_diagonal.size
        @lower_diagonal[i] = @lower_diagonal[i] - other.lower_diagonal[i]
      end

      for i in 0...@upper_diagonal.size
        @upper_diagonal[i] = @upper_diagonal[i] - other.upper_diagonal[i]
      end

      # Post:
      # for i in old.shape.m
      #   for j in old.shape.n
      #     assert(self[i,j] == old[i,j] - other[i,j])
      #   end
      # end
    end

    def transpose()
      # Pre:
      # assert(old = self.clone)

      temp_vector = @lower_diagonal
      @lower_diagonal = @upper_diagonal
      @upper_diagonal = temp_vector

      # Post:
      # for i in old.shape.m
      #   for j in old.shape.n
      #     assert(old[i,j] == self[j,i])
      #   end
      # end
    end

    def multiply(other)
      # Pre:
      # assert(other.n == @shape.m)

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] * other.main_diagonal[i]
      end

      for i in 0...@lower_diagonal.size
        @lower_diagonal[i] = @lower_diagonal[i] * other.lower_diagonal[i]
      end

      for i in 0...@upper_diagonal.size
        @upper_diagonal[i] = @upper_diagonal[i] * other.upper_diagonal[i]
      end

    end

    def determinant()
    end

    def inverse()

    end

  end

  # TODO: DELETE IT, ONLY USING FOR TESTING
  s1 = [[1,2,0,0], [3,4,5,0], [0,6,7,8], [0,0,9,10]]
  s2 = [[3,1,0,0], [5,2,6,0], [0,1,5,1], [0,0,2,1]]
  s3 = [[1,2,0], [4,5,6], [0,8,9]]

  matrix_1 = TridiagonalSparseMatrix.new(s1)
  matrix_2 = TridiagonalSparseMatrix.new(s2)
  matrix_3 = TridiagonalSparseMatrix.new(s3)

  # p "Accessing Elements of matrix"
  # p matrix_3[0,0] ,matrix_3[0,1], matrix_3[0,2]


  # matrix_1.add(matrix_2)
  # matrix_1.subtract(matrix_2)
  # matrix_1.multiply(matrix_2)
  # matrix_1.transpose

end


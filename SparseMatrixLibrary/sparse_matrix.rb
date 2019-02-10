module SparseMatrix

require 'test/unit'
require 'nmatrix'

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

    def to2DArray()
      raise NotImplementedError
    end

  end

  class YaleSparseMatrix < AbstractMatrix
    include Test::Unit::Assertions
    attr_reader :numRows, :numColumns, :nmatrix

    def initialize(nmatrix)
      @nmatrix = nmatrix
      update_dimensions
    end

    def update_dimensions()
      @numRows = @nmatrix.shape[0]
      @numColumns = @nmatrix.shape[1]
    end

    def [](m, n)
      # Pre:
      assert((0 <= m) && (m < @numRows))
      assert((0 <= n) && (n < @numColumns))

      @nmatrix[m, n]
    end

    def []=(m, n, v)
      # Pre:
      assert((0 <= m) && (m < @numRows))
      assert((0 <= n) && (n < @numColumns))

      @nmatrix[m, n] = v

      # Post:
      assert(self[m,n] == v)
    end

    def transpose()
      # Pre:
      old = self.clone

      @nmatrix = @nmatrix.transpose
      update_dimensions

      # Post:
      for i in 0...old.numRows
        for j in 0...old.numColumns
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

      @nmatrix = @nmatrix + other.nmatrix

      # Post:
      for i in 0...old.numRows
        for j in 0...old.numColumns
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

      @nmatrix = @nmatrix - other.nmatrix

      # Post:
      for i in 0...old.numRows
        for j in 0...old.numColumns
          assert(self[i,j] == old[i,j] - other[i,j])
        end
      end
    end

    def multiply(other)
      # Pre:
      assert(other.is_a?(YaleSparseMatrix))
      assert(@numColumns == other.numRows)
      old_numRows = @numRows
      old_numColumns = @numColumns

      @nmatrix = @nmatrix.dot(other.nmatrix)
      update_dimensions

      # Post:
      assert(@numRows == old_numRows)
      assert(@numColumns == other.numColumns)
    end

    def determinant()
      # Pre:
      assert(@numRows == @numColumns)
      @nmatrix.det
    end

    def inverse()
      # Unfortunately, NMatrix does not provide implementation for inverse for
      # non-dense matrices, thus the cast.
      @nmatrix = @nmatrix.cast(:stype => :dense)
      @nmatrix = @nmatrix.inverse
      @nmatrix = @nmatrix.cast(:stype => :yale)
    end

    def collect()
      assert(block_given?)
      @nmatrix.each_with_indices{|v, m, n| self[m,n] = yield(v)}
    end

    def to_s()
      @nmatrix.to_s
    end

    def to2DArray
      @nmatrix.to_a
    end

  end

  class TridiagonalSparseMatrix < AbstractMatrix
    attr_reader :main_diagonal
    attr_reader :lower_diagonal
    attr_reader :upper_diagonal
    attr_reader :numColumns
    attr_reader :numRows

    def initialize(matrix, numRows, numColumns)
      # Pre:
      raise "numRows must be > 0" unless (numRows > 0)
      raise "numColumsn must be > 0" unless (numColumns > 0)

      @main_diagonal  = Array.new
      @lower_diagonal = Array.new
      @upper_diagonal  = Array.new
      @numRows = numRows
      @numColumns = numColumns

      for i in 0...matrix.size
        for j in 0...matrix[i].size

          if i==j   then @main_diagonal.push(matrix[i][j])  end
          if i==j+1 then @lower_diagonal.push(matrix[i][j]) end
          if i==j-1 then @upper_diagonal.push(matrix[i][j])  end

        end
      end

    end

    def [](m, n)
      # Pre:
      raise IndexError unless (0 <= m and m < @numRows)
      raise IndexError unless (0 <= n and n < @numColumns)

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
      raise IndexError unless (0 <= m and m < @numRows)
      raise IndexError unless (0 <= n and n < @numColumns)

      # return 0 as indices not in the diagonals
      if m!=n and m!=n-1 and m!=n+1
        raise "Error: In Tri-diagonal Matrix, can only change the 3 diagonal values"
      end

      # return from the main diagonal
      if m==n and m < main_diagonal.size
        main_diagonal[m] = v

        # return from the first diagonal below main diagonal
      elsif m==n+1 and m - 1 < lower_diagonal.size
        lower_diagonal[m-1] = v

        # return from the first diagonal above main diagonal
      elsif m==n-1 and m < upper_diagonal.size
        upper_diagonal[m] = v

      else
        raise "Error"
      end

      # Post:
      raise "Set operation failed" unless (self[m,n] == v)
    end

    def add(other)
      # Pre:
      raise TypeError unless (other.is_a?(TridiagonalSparseMatrix))
      raise IndexError unless (other.numRows == @numRows)
      raise IndexError unless (other.numColumns == @numColumns)
      old = self.clone

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] + other.main_diagonal[i]
        if i < @lower_diagonal.size then @lower_diagonal[i] = @lower_diagonal[i] + other.lower_diagonal[i] end
        if i < @upper_diagonal.size then @upper_diagonal[i] = @upper_diagonal[i] + other.upper_diagonal[i] end
      end

      # Post:
      # Check that dimensions haven't been mutated
      raise "Add operation failed" unless (old.numColumns == self.numColumns)
      raise "Add operation failed" unless (old.numRows == self.numRows)
    end

    def subtract(other)
      # Pre:
      raise TypeError unless (other.is_a?(TridiagonalSparseMatrix))
      raise IndexError unless (other.numRows == @numRows)
      raise IndexError unless (other.numColumns == @numColumns)
      old = self.clone

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] - other.main_diagonal[i]
        if i < @lower_diagonal.size then @lower_diagonal[i] = @lower_diagonal[i] - other.lower_diagonal[i] end
        if i < @upper_diagonal.size then @upper_diagonal[i] = @upper_diagonal[i] - other.upper_diagonal[i] end
      end

      # Post:
      # Check that dimensions haven't been mutated
      raise "Add operation failed" unless (old.numColumns == self.numColumns)
      raise "Add operation failed" unless (old.numRows == self.numRows)
    end

    def transpose()
      # Pre:
      old = self.clone

      temp_vector = @lower_diagonal
      @lower_diagonal = @upper_diagonal
      @upper_diagonal = temp_vector

      tempElementCount = @numColumns
      @numColumns = @numRows
      @numRows = tempElementCount

      # Post:
      raise "Transpose operation failed" unless (old.numColumns == self.numRows)
      raise "Transpose operation failed" unless (old.numRows == self.numColumns)
    end

    def multiply(other)
      # Pre:
      # assert(other.n == @shape.m)

      for i in 0...@main_diagonal.size
        @main_diagonal[i] = @main_diagonal[i] * other.main_diagonal[i]
        if i < @lower_diagonal.size then @lower_diagonal[i] = @lower_diagonal[i] * other.lower_diagonal[i] end
        if i < @upper_diagonal.size then @upper_diagonal[i] = @upper_diagonal[i] * other.upper_diagonal[i] end
      end

    end

    def determinant()
      # For tri-diagonal matrices, the determinant is represented by a special
      # sequence called the continuent
      continuentMemo = Hash.new # (fn, result)
      continuentMemo.store(-1, 0)
      continuentMemo.store(0, 1)
      continuentMemo.store(1, @main_diagonal[0])

      return compute_continuant(continuentMemo, @main_diagonal.size)
    end

    def inverse()
      # For Tri-diagonal matrices we use R. A. Usmani's specialized algorithm
      # Since the inverse of a tri-diagonal matrix may not be tri-diagonal,
      # we opt to return a 2D-array instead
      # Pre:
      raise "Cannot call inverse() on non-square matrices" unless (@numColumns == @numRows)

      n = @main_diagonal.size
      
      result = Array.new(@numRows) {Array.new(@numColumns)}

      continuentMemo = Hash.new # (fn, result)
      continuentMemo.store(0, 1)
      continuentMemo.store(1, @main_diagonal[0])
      compute_continuant(continuentMemo, n)

      phiMemo = Hash.new
      phiMemo.store(n + 1, 1)
      phiMemo.store(n, @main_diagonal[n - 1])
      phi_n = compute_phi(phiMemo, 1)

      for i in 0...n
        for j in 0...n
          if i == j
            recurrenceCoeff = (continuentMemo[i].to_f*phiMemo[j+2].to_f)/continuentMemo[n].to_f
            result[i][j] = recurrenceCoeff
          
          elsif i < j
            recurrenceCoeff = (continuentMemo[i].to_f*phiMemo[j+2].to_f)/continuentMemo[n].to_f
            signCoeff = (-1)**(i+j+2)
            elementTerm = 1.to_f
            for k in i...j
              elementTerm = elementTerm*@upper_diagonal[k].to_f
            end
            result[i][j] = recurrenceCoeff*elementTerm*signCoeff

          elsif i > j
            recurrenceCoeff = (continuentMemo[j].to_f*phiMemo[i+2].to_f)/continuentMemo[n].to_f
            signCoeff = (-1)**(i+j+2)
            elementTerm = 1.to_f
            for k in j...i
              elementTerm = elementTerm*@lower_diagonal[k].to_f
            end

            result[i][j] = recurrenceCoeff*elementTerm*signCoeff

          end
        end
      end

      return result
    end

    def to2DArray()
      result = Array.new(@numRows) {Array.new(@numColumns)}
      for i in 0...result.size
        for j in 0...result[i].size
          result[i][j] = self[i, j]
        end
      end

      return result
    end

    private

    def compute_continuant(continuentMemo, sequenceIndex)
      # The continuent is a special sequence that represents the determinant of a tri-diagonal matrix
      if continuentMemo.key?(sequenceIndex)
        return continuentMemo[sequenceIndex]

      else
        result = @main_diagonal[sequenceIndex - 1]*compute_continuant(continuentMemo, sequenceIndex - 1) - @lower_diagonal[sequenceIndex - 2] * @upper_diagonal[sequenceIndex - 2] * compute_continuant(continuentMemo, sequenceIndex - 2)
        continuentMemo.store(sequenceIndex, result)
        return result
      end
    end

    def compute_phi(phiMemo, sequenceIndex)
      # The phi sequence is required to compute the inverse of a tri-diagonal matrix 
      if phiMemo.key?(sequenceIndex)
        return phiMemo[sequenceIndex]
      
      else
        result = @main_diagonal[sequenceIndex-1]*compute_phi(phiMemo, sequenceIndex+1) - @lower_diagonal[sequenceIndex-1]*@upper_diagonal[sequenceIndex-1]*compute_phi(phiMemo, sequenceIndex+2)
        phiMemo.store(sequenceIndex, result)
        return result
      end
    end

  end

  # TODO: DELETE IT, ONLY USING FOR TESTING
  s1 = [[1,2,0,0], [3,4,5,0], [0,6,7,8], [0,0,9,10]]
  s2 = [[3,1,0,0], [5,2,6,0], [0,1,5,1], [0,0,2,1]]
  s3 = [[1,2,0], [4,5,6], [0,8,9]]
  s4 = [[5,1,0,0,0], [1,4,2,0,0], [0,2,3,4,0], [0,0,4,2,3], [0,0,0,3,1]]

  # matrix_1.add(matrix_2)
  # matrix_1.subtract(matrix_2)
  # matrix_1.multiply(matrix_2)
  # matrix_1.transpose
  #
end


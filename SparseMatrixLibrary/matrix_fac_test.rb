require_relative './matrix_factory'
require 'test/unit'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @one_matrix = [
        [1,1,0,0,0],
        [1,1,1,0,0],
        [0,1,1,1,0],
        [0,0,1,1,1],
        [0,0,0,1,1]

    ]
    @tri_matrix = [
        [5,1,0,0,0],
        [1,4,2,0,0],
        [0,2,3,4,0],
        [0,0,4,2,3],
        [0,0,0,3,1]
    ]

    @matrixFactory = TridiagonalMatrixFactory.new
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  #
  def test_zero_matrix
    zero = @matrixFactory.CreateZeroes(3,4)
    for i in 0..2
      for j in 0..3
        assert_equal(zero[i,j],0)
      end
    end
  end

  def test_identity_matrx
    iden = @matrixFactory.CreateIdentity(5)
    for i in 0..4
      for j in 0..4
        if (i ==j)
          assert_equal(iden[i,j],1)
        end
      end
    end

  end

  def test_one_matrix
    one = @matrixFactory.CreateOnes(5,5).to2DArray
    for i in 0..4
      for j in 0..4
        assert_equal(one[i,j],@one_matrix[i,j])
      end
    end
  end


  def test_init
    tri = @matrixFactory.Create([5,1,0,0,0], [1,4,2,0,0], [0,2,3,4,0], [0,0,4,2,3], [0,0,0,3,1]).to2DArray()
    for i in 0..4
      for j in 0..4
        assert_equal(@tri_matrix[i,j],tri[i,j])
      end
    end
  end



  def teardown
    # Do nothing
  end


  # Fake test
  def test_fail

    # fail('Not implemented')
  end
end
require_relative './sparse_matrix'
require 'test/unit'



class Trigdiagonal_matrix_Test < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @null_tri_matrix = []

    @non_tri_matrix = [
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,88,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,1,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,20,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0]
    ]


    @one_tri_matrix_neg = [
        [-1,-1,0,0,0,0,0,0,0,0,0],
        [-1,-1,-1,0,0,0,0,0,0,0,0,0],
        [0,-1,-1,-1,0,0,0,0,0,0,0,0],
        [0,0,-1,-1,-1,0,0,0,0,0,0,0],
        [0,0,0,-1,-1,-1,0,0,0,0,0,0],
        [0,0,0,0,-1,-1,-1,0,0,0,0,0],
        [0,0,0,0,0,-1,-1,-1,0,0,0,0],
        [0,0,0,0,0,0,-1,-1,-1,0,0,0],
        [0,0,0,0,0,0,0,-1,-1,-1,0,0],
        [0,0,0,0,0,0,0,0,-1,-1,-1,0],
        [0,0,0,0,0,0,0,0,0,-1,-1,-1],
        [0,0,0,0,0,0,0,0,0,0,-1,-1]
    ]

    @one_tri_matrix = [
        [1,1,0,0,0,0,0,0,0,0,0],
        [1,1,1,0,0,0,0,0,0,0,0,0],
        [0,1,1,1,0,0,0,0,0,0,0,0],
        [0,0,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,0,0,0,0,0,0],
        [0,0,0,0,1,1,1,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,0,0,0,0],
        [0,0,0,0,0,0,1,1,1,0,0,0],
        [0,0,0,0,0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,0,1,1,1,0],
        [0,0,0,0,0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,0,0,0,0,1,1]
    ]
    @three_tri_matrix = [
        [3,3,0,0,0,0,0,0,0,0,0],
        [3,3,3,0,0,0,0,0,0,0,0,0],
        [0,3,3,3,0,0,0,0,0,0,0,0],
        [0,0,3,3,3,0,0,0,0,0,0,0],
        [0,0,0,3,3,3,0,0,0,0,0,0],
        [0,0,0,0,3,3,3,0,0,0,0,0],
        [0,0,0,0,0,3,3,3,0,0,0,0],
        [0,0,0,0,0,0,3,3,3,0,0,0],
        [0,0,0,0,0,0,0,3,3,3,0,0],
        [0,0,0,0,0,0,0,0,3,3,3,0],
        [0,0,0,0,0,0,0,0,0,3,3,3],
        [0,0,0,0,0,0,0,0,0,0,3,3]
    ]

    @zero_tri_matrix = [
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0]
    ]
    @nor_tri_matrix = [
        [1,2,0,0,0,0,0,0,0,0,0,0],
        [3,4,5,0,0,0,0,0,0,0,0,0],
        [0,7,8,9,0,0,0,0,0,0,0,0],
        [0,0,1,2,3,0,0,0,0,0,0,0],
        [0,0,0,5,6,7,0,0,0,0,0,0],
        [0,0,0,0,6,7,9,0,0,0,0,0],
        [0,0,0,0,0,3,4,5,0,0,0,0],
        [0,0,0,0,0,0,9,2,1,0,0,0],
        [0,0,0,0,0,0,0,4,3,7,0,0],
        [0,0,0,0,0,0,0,0,2,4,7,0],
        [0,0,0,0,0,0,0,0,0,1,2,3],
        [0,0,0,0,0,0,0,0,0,0,4,9]
    ]

    @nor_tri_matrix_tran=[
        [1,3,0,0,0,0,0,0,0,0,0,0],
        [2,4,7,0,0,0,0,0,0,0,0,0],
        [0,5,8,1,0,0,0,0,0,0,0,0],
        [0,0,9,2,5,0,0,0,0,0,0,0],
        [0,0,0,3,6,6,0,0,0,0,0,0],
        [0,0,0,0,7,7,3,0,0,0,0,0],
        [0,0,0,0,0,9,4,9,0,0,0,0],
        [0,0,0,0,0,0,5,2,4,0,0,0],
        [0,0,0,0,0,0,0,1,3,2,0,0],
        [0,0,0,0,0,0,0,0,7,4,1,0],
        [0,0,0,0,0,0,0,0,0,7,2,4],
        [0,0,0,0,0,0,0,0,0,0,3,9]
    ]

    @matrix_5_5 = [
        [1,3,0,0,0],
        [9,2,1,0,0],
        [0,3,2,1,0],
        [0,0,2,11,3],
        [0,0,0,2,1]
    ]

    # initializae different type of tridiagonal matrix with same diamention 12*12
    @tri_zero_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  #


  def teardown

    # Do nothing
  end

  def test_assign_value
    # mid
    for i in 0..11
      @tri_zero_matrix[i,i] = i+1;
    end
    # up
    for j in 0..10
      @tri_zero_matrix[j+1,j] = j+10;
    end
    # down
    for k in 0..10
      @tri_zero_matrix[k,k+1] = k+5;
    end

    counter = 0;
    for num in [1,2,3,4,5,6,7,8,9,10,11]
      assert_equal(num,@tri_zero_matrix[counter,counter])
      counter+= 1
    end

    counter = 0;
    for num in [0,1,2,3,4,5,6,7,8,9]
      assert_equal(@tri_zero_matrix[counter+1,counter],num+10)
      assert_equal(@tri_zero_matrix[counter,counter+1],num+5)
      counter+= 1
    end
  end


  def test_addition
    # add itself is euqal to itself

    tri_zero_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    tri_zero_matrix::add(tri_zero_matrix)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,tri_zero_matrix)
    assert_equal(tri_zero_matrix,tri_zero_matrix)

    # zero matrix add any matrix is equal to itself
    tri_zero_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    nor_tri_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@nor_tri_matrix,12,12)
    nor_tri_matrix::add(tri_zero_matrix)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,nor_tri_matrix)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,tri_zero_matrix)
    assert_equal(nor_tri_matrix,nor_tri_matrix)

    # non zero matrix add any matrix
    one_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    three_matrix = SparseMatrix::TridiagonalSparseMatrix.new(@three_tri_matrix,12,12)
    (SparseMatrix::TridiagonalSparseMatrix)
    one_matrix::add(one_matrix)
    one_matrix_2 = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    one_matrix::add(one_matrix_2)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,one_matrix)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,three_matrix)
    assert(one_matrix == three_matrix,"false")

  end

  def test_subtract
    zero_tri = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    one_tri  = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    neg_one_tri = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix_neg,12,12)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,zero_tri)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,one_tri)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,neg_one_tri)
    # zero - one = -one
    zero_tri::subtract(one_tri)
    assert_equal(zero_tri,neg_one_tri)
    # -one + one = zero
    zero_tri::add(one_tri)
    assert_equal(zero_tri,zero_tri)
    # one - zero = one
    one_tri.subtract(zero_tri)
    assert_equal(one_tri,one_tri)
    # zero - zero = zero
    zero_tri.subtract(zero_tri)
    assert_equal(zero_tri,zero_tri)
  end

  def test_transpose
    nor_trig = SparseMatrix::TridiagonalSparseMatrix.new(@nor_tri_matrix,12,12)
    trans_nor_trig = SparseMatrix::TridiagonalSparseMatrix.new(@nor_tri_matrix_tran,12,12)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,nor_trig)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,trans_nor_trig)
    nor_trig::transpose()
    assert(nor_trig == trans_nor_trig, "false")

    # zero transpose is equal to itself
    zero_trig = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    zero_trig::transpose()
    assert_equal(zero_trig,zero_trig)
  end

  def test_multiplication
    zero_trig = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    assert_kind_of(SparseMatrix::TridiagonalSparseMatrix,zero_trig)
    zero_trig::multiply(zero_trig)
    assert_equal(zero_trig,zero_trig)


    zero_trig = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
    one_trig = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    neg_one_trig = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix_neg,12,12)
    nor_trig = SparseMatrix::TridiagonalSparseMatrix.new(@nor_tri_matrix_tran,12,12)
    one_trig::multiply(zero_trig)
    neg_one_trig::multiply(zero_trig)
    assert_equal(zero_trig,one_trig)
    assert_equal(zero_trig,neg_one_trig)


    one_trig = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    neg_one_trig = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix_neg,12,12)
    one_trig::multiply(neg_one_trig)
    assert_equal(one_trig,neg_one_trig)

    one_trig = SparseMatrix::TridiagonalSparseMatrix.new(@one_tri_matrix,12,12)
    three_trig = SparseMatrix::TridiagonalSparseMatrix.new(@three_tri_matrix,12,12)
    one_trig::multiply(three_trig)
    assert_equal(one_trig,three_trig)
  end

  def test_determinant
    matrix_1 = SparseMatrix::TridiagonalSparseMatrix.new(@matrix_5_5,5,5)
    assert_equal( matrix_1::determinant(),-215)
  end

  def test_inverse
    matrix_1 = SparseMatrix::TridiagonalSparseMatrix.new(@matrix_5_5,5,5)
    result = matrix_1::inverse()

    expected_result = [
        [-0.004651,0.111628,-0.069767,0.0139535,-0.041860],
        [0.334884,-0.037209, 0.023256,-0.004651 ,0.013953],
        [-0.627907 ,0.069767 ,0.581395 ,-0.116279 ,0.348837],
        [0.251163 ,-0.027907 ,-0.232558 ,0.246512 ,-0.739535],
        [-0.502326 ,0.055814 ,0.465116 ,-0.493023 ,2.479070]
    ]
    for i in 0..4
      for j in 0..4
        assert_in_delta(result[i][j], expected_result[i][j],0.001)


      end

    end

  end

  # error testing


  def test_null_trig
    assert_raises RuntimeError do
      error_matrix_0_index = SparseMatrix::TridiagonalSparseMatrix.new(@null_tri_matrix,0,0)
      error_matrix_null_array = SparseMatrix::TridiagonalSparseMatrix.new(@nor_tri_matrix_tran,10,10)
    end
  end


    def test_outof_index
      assert_raises IndexError do
        matrix_small = SparseMatrix::TridiagonalSparseMatrix.new(@matrix_5_5,5,5)
        zero_trig = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
        zero_trig[99,99] = 0
        matrix_small::add(zero_trig)
        matrix_small::subtract(zero_trig)
      end
    end

    def test_type_error
      assert_raises TypeError do
        zero_trig = SparseMatrix::TridiagonalSparseMatrix.new(@zero_tri_matrix,12,12)
        zero_trig::add([1,2,3])
        zero_trig::subtract([1,2,3])
      end
    end


end
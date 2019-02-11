require_relative './sparse_matrix'
require_relative './matrix_factory'
require 'test/unit'

class Sparse_matrix_test < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # issue on finding the determinnat
    #
    @sparse_nor_2=N[
        [1,2,3,4,5],
        [0,0,2,4,5],
        [0,2,1,1,1],
        [3,4,5,9,9],
        [2,5,6,7,8]
    ]

    #

    # @sparse_nor_2=N[
    #     [1,0,0,0],
    #     [1,2,1,1],
    #     [1,1,3,1],
    #     [1,1,1,4]
    # ]

    # @sparse_nor_2=N[
    # [1,0,0,0,0,0,0],
    # [0,1,0,0,0,0,0],
    # [0,0,2,0,0,0,0],
    # [0,0,0,1,0,0,0],
    # [0,0,0,0,2,0,0],
    # [0,0,0,0,0,1,0],
    # [0,0,0,0,0,0,1]
    # ]

    @zero_sparse = N[
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
    @sparse_nor = N[
        [0,0,0,0,0,3,0],
        [10,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,3,0],
        [4,0,0,0,0,0,0],
        [0,0,0,5,0,0,0]
    ]
    @mul_sparse_nor = N[
        [0,0,0,0,0,9,0],
        [100,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,9,0],
        [16,0,0,0,0,0,0],
        [0,0,0,25,0,0,0]
    ]

    @neg_sparse_nor = N[
        [0,0,0,0,0,-3,0],
        [-10,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,-3,0],
        [-4,0,0,0,0,0,0],
        [0,0,0,-5,0,0,0]
    ]
    @sparse_nor_2 = N[
        [0,0,0,0,0,6,0],
        [20,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,6,0],
        [8,0,0,0,0,0,0],
        [0,0,0,10,0,0,0]

    ]



    @sparse_nor_tran = N[
        [0,10,0,0,0,4,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,5],
        [0,0,0,0,0,0,0],
        [3,0,0,0,3,0,0],
        [0,0,0,0,0,0,0]
    ]
    @sparse_null = N[]
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_init
    sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@zero_sparse)
    sparse_null = SparseMatrix::YaleSparseMatrix.new(@sparse_null)
  end

  def test_value
    sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    assert_equal(sparse_matrix[1,0],10)
    sparse_matrix[1,0] = 100
    assert_equal(sparse_matrix[1,0], 100)
  end
  def value_error
    sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    assert_raises IndexError do
      sparse_matrix[100,0]
      sparse_matrix[100,0] = 10
    end
  end

  def  test_transpose
    sparse_matrix_tran = SparseMatrix::YaleSparseMatrix.new(@sparse_nor_tran)
    sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    sparse_matrix::transpose()
    for i in 0...sparse_matrix.numRows
      for j in 0...sparse_matrix.numColumns
        assert(sparse_matrix[i,j] == sparse_matrix_tran[i,j])
      end
    end
  end

  def test_addition
    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    sparse_matrix_2 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    reuslt = SparseMatrix::YaleSparseMatrix.new(@sparse_nor_2)
    sparse_matrix_1::add(sparse_matrix_2)
    assert(sparse_matrix_1==reuslt)

    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    zero_sparse = SparseMatrix::YaleSparseMatrix.new(@zero_sparse)
    sparse_matrix_1::add(zero_sparse)
    assert(sparse_matrix_1 == sparse_matrix_1)


    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    neg_sparse = SparseMatrix::YaleSparseMatrix.new(@neg_sparse_nor)
    sparse_matrix_1::add(neg_sparse)
    assert(sparse_matrix_1 == zero_sparse)



  end

  def test_subtraction
    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    sparse_matrix_2 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    zero_sparse = SparseMatrix::YaleSparseMatrix.new(@zero_sparse)
    sparse_matrix_1::subtract(sparse_matrix_2)
    assert(sparse_matrix_1 == zero_sparse)

    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    neg_sparse = SparseMatrix::YaleSparseMatrix.new(@neg_sparse_nor)
    zero_sparse = SparseMatrix::YaleSparseMatrix.new(@zero_sparse)
    zero_sparse::subtract(sparse_matrix_1)
    assert(zero_sparse == neg_sparse)

  end
  def test_mutiplication
    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    zero_sparse  =SparseMatrix::YaleSparseMatrix.new(@zero_sparse)
    sparse_matrix_1::multiply(zero_sparse)
    assert(sparse_matrix_1 == zero_sparse)

    sparse_matrix_1 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    sparse_matrix_2 = SparseMatrix::YaleSparseMatrix.new(@sparse_nor)
    m_sparse_matrix = SparseMatrix::YaleSparseMatrix.new(@mul_sparse_nor)
    sparse_matrix_1::multiply(sparse_matrix_2)
    assert(sparse_matrix_1 == m_sparse_matrix)
  end
# issue on the determinant and find teh inverse

  def test_determinant
    f = YaleSparseMatrixFactory.new()
    c = f.Create([1,2,3,4,5],[0,0,2,4,5],[0,2,1,1,1],[3,4,5,9,9],[2,5,6,7,8])
    result = c.determinant()
    assert_equal(result,15)
    # assert_equal(result , )


  end
  def test_inverse
    f = YaleSparseMatrixFactory.new
    c = f.Create([1,2,3,4,5],[0,0,2,4,5],[0,2,1,1,1],[3,4,5,9,9],[2,5,6,7,8])
    d = c.clone()
    d.inverse
    c.multiply(d)

    one = f.CreateIdentity(5)
    for i in 0..4
      for j in 0..4
        assert_in_delta(one[i,j],c[i,j],0.001)
      end
    end
    
  end

end
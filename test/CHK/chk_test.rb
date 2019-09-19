# chk_test.rb

require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test

  def test_chk
    assert_equal 0, Checkout.new.checkout(""), "Empty basket should cost nothing"

    assert_equal -1, Checkout.new.checkout("ABCDE"), "Basket with non-existent products should return -1"
    assert_equal -1, Checkout.new.checkout(100), "Non-string basket should return -1"
  end

  def test_valid_sku?
    assert_equal true, Checkout.valid_sku?("A"), "A is a valid sku"
    # assert_equal false, Checkout.valid_sku?("Q"), "Q is not a valid sku"
  end

  def test_prices


  end

end




# chk_test.rb

require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test

  def test_chk
    assert_equal 0, Checkout.new.checkout(""), "Empty basket should cost nothing"

    assert_equal 50, Checkout.new.checkout("A"), "Checkout with a single A should cost 50"

    assert_equal 100, Checkout.new.checkout("ABC"), "Checkout with ABC should cost 100"

    assert_equal(-1, Checkout.new.checkout("ABCDE"), "Basket with non-existent products should return -1")
    assert_equal(-1, Checkout.new.checkout(100), "Non-string basket should return -1")
  end

  def test_valid_sku?
    assert_equal true, Checkout.valid_sku?("A"), "A is a valid sku"
    assert_equal false, Checkout.valid_sku?("Q"), "Q is not a valid sku"
  end

  def test_prices
    assert_equal 50, Checkout.single_price("A"), "One A should cost 50"
    assert_equal 30, Checkout.single_price("B"), "One B should cost 30"

    assert_equal nil, Checkout.single_price("Q"), "Invalid sku should return nil price"
  end

  def test_discounts
    assert_equal [3, 150], Checkout.discount("A"), "Discount on As should be 3 for 150"
  end

end

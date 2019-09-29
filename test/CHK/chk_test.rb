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

    assert_equal 150, Checkout.new.checkout("AAAC"), "Checkout with AAAC should cost 150"
    assert_equal 220, Checkout.new.checkout("AAAAAC"), "Checkout with AAAC should cost 220"
    assert_equal 175, Checkout.new.checkout("ABABA"), "Checkout with ABABA should cost 175"
    assert_equal 80, Checkout.new.checkout("EEB"), "Checkout with EEB should cost 80"
    assert_equal 20, Checkout.new.checkout("FFF"), "Checkout with FFF should cost 20"
    assert_equal 20, Checkout.new.checkout("FF"), "Checkout with FF should cost 20"
    assert_equal 90, Checkout.new.checkout("VV"), "Checkout with VV should cost 90"
    assert_equal 130, Checkout.new.checkout("VVV"), "Checkout with VVV should cost 130"
    assert_equal 150, Checkout.new.checkout("RRRQ"), "Checkout with RRRQ should cost 150"
    assert_equal 45, Checkout.new.checkout("HHHHH"), "Checkout with HHHHH should cost 45"
    assert_equal 80, Checkout.new.checkout("QQQ"), "Checkout with QQQ should cost 80"
    assert_equal 120, Checkout.new.checkout("NNNM"), "Checkout with NNNM should cost 120"


    assert_equal Checkout.new.checkout("ABABA"), Checkout.new.checkout("AAABB"), "Reordering basket items shouldn't affect the price"

    assert_equal 455, Checkout.new.checkout("AAAAAEEBAAABB"), "Big baskets shouldn't cause issues"
    assert_equal 900, Checkout.new.checkout("AAAAAEEBAAABBAAAAAEEBAAABB"), "Really big baskets shouldn't cause issues"

    assert_equal(-1, Checkout.new.checkout("ABCDEFG0"), "Basket with non-existent products should return -1")
    assert_equal(-1, Checkout.new.checkout(100), "Non-string basket should return -1")
  end

  def test_valid_sku?
    assert_equal true, Checkout.valid_sku?("A"), "A is a valid sku"
    assert_equal false, Checkout.valid_sku?("0"), "0 is not a valid sku"
  end

  def test_prices
    assert_equal 50, Checkout.single_price("A"), "One A should cost 50"
    assert_equal 30, Checkout.single_price("B"), "One B should cost 30"

    assert_equal nil, Checkout.single_price("0"), "Invalid sku should return nil price"
  end

  def test_apply_discount
    assert_equal({}, Checkout.apply_discount("A", {"A" => 1}))
    assert_equal({}, Checkout.apply_discount("AAA", {"A" => 3}))
    assert_equal({"B" => 2}, Checkout.apply_discount("AAA", {"A" => 3, "B" => 2}))
  end

  def test_discounts
    assert_equal 130, Checkout.discount("AAA"), "Discount on As should be 3 for 130"
  end

end




# noinspection RubyUnusedLocalVariable
class Checkout

  PRICES =
    {
      "A" => 50,
      "B" => 30,
      "C" => 20,
      "D" => 15
    }

  DISCOUNTS =
    {
      "A" => [3, 150],
      "B" => [2, 45]
    }

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }

    each_sku_count = Hash.new 0
    skus.each_char do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    puts each_sku_count

    price_after_discounting, remaining_products = Checkout.discount_basket each_sku_count

    puts price_after_discounting
    total_base_prices = remaining_products.each.reduce(0) do |acc, sku, count|
      acc + (Checkout.single_price(sku) * count)
    end

    puts total_base_prices

    return price_after_discounting + total_base_prices
  end

  def self.valid_sku?(sku)
    ("A".."D").include? sku
  end

  def self.single_price(sku)
    PRICES[sku]
  end

  def self.discount(sku)
    DISCOUNTS[sku]
  end

  def self.discount_basket(basket)
    discounted_total = 0
    leftovers = {}
    basket.each do |sku, count|
      DISCOUNTS.fetch(sku) do |num_for_discount, discount_total|
      leftovers[sku] = count.modulo num_for_discount
      discounted_total = discounted_total + (count.div(num_for_discount) * discount_total)
      end
    end
    [discounted_total, leftovers]
  end


end








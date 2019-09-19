# noinspection RubyUnusedLocalVariable
class Checkout

  PRICES =
    {
      "A" => 50,
      "B" => 30,
      "C" => 20,
      "D" => 15,
      "E" => 40
    }

  DISCOUNTS =
    {
      "AAA" => 130,
      "BB" => 45
    }

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }

    each_sku_count = Hash.new 0
    skus.each_char do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    price_after_discounting, remaining_products = Checkout.discount_basket each_sku_count

    total_base_prices = remaining_products.each.reduce(0) do |acc, val|
      sku, count = val
      acc + (Checkout.single_price(sku) * count)
    end

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
      if discount = DISCOUNTS[sku] then
        num_for_discount, discount_total = discount
        leftovers[sku] = count.modulo num_for_discount
        discounted_total = discounted_total + (count.div(num_for_discount) * discount_total)
      else
        leftovers[sku] = count
      end
    end
    [discounted_total, leftovers]
  end


end





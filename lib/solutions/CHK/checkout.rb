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
    }.merge(PRICES)

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }

    each_sku_count = Hash.new 0
    skus.each_char do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    price_after_discounting, remaining_products = Checkout.traverse_discounts 0, each_sku_count

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

  def self.apply_discount(discount, basket)
    reduced_basket = basket.clone
    discount.each_char.each do |c|
      reduced_basket[c] = reduced_basket[c] - 1
    end
    puts discount_hash
  end

  def self.traverse_discounts(total, basket)

    applieds = DISCOUNTS.map do |discount, val|
      # if this discount is applicable, remove the products and recurse

      if new_basket = self.apply_discount(discount, basket) then
        [val, new_basket]
      else nil
      end
    end

    puts applieds

    return [0, {}]

  end


end




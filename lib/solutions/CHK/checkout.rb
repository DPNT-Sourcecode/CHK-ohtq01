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

    price, remaining_products = Checkout.traverse_discounts 0, each_sku_count

    return price
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
    reduced_basket.delete_if do |k, v| v == 0 end
    if reduced_basket.values.all? { |v| v >= 0 } then
      reduced_basket
    else
      nil
    end
  end

  def self.traverse_discounts(total, basket)

    applieds = DISCOUNTS.map do |discount, val|
      # if this discount is applicable, remove the products and recurse

      if new_basket = self.apply_discount(discount, basket) then
        [val, new_basket]
      else nil
      end
    end

    puts applieds.reject{|v| v.nil?}.inspect

    return [0, {}]

  end


end






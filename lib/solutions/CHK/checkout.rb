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
      "AAAAA" => 200,
      "BB" => 45,
      "EEB" => 80
    }.merge(PRICES)

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }
    return 0 if skus.empty?

    each_sku_count = Hash.new 0
    skus.each_char do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    Checkout.traverse_discounts(0, each_sku_count).map(&:first).min

  end

  def self.valid_sku?(sku)
    ("A".."E").include? sku
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

    # remove all products which we now have none of
    reduced_basket.delete_if do |k, v| v == 0 end


    if reduced_basket.values.all? { |v| v >= 0 } then
      reduced_basket
    else
      nil
    end
  end

  def self.traverse_discounts(total, basket)

    applieds = DISCOUNTS.map do |discount, val|
      # if this discount is applicable, remove the products and
      #   add the price of the discount to the total

      if new_basket = self.apply_discount(discount, basket) then
        [total + val, new_basket]
      else nil
      end
    end

    # drop all the invalid discounts we tried to apply and
    #   and then recurse
    options = applieds.reject{|v| v.nil?}.flat_map do |total, basket|
      if basket.empty? then
        [[total, basket]]
      else
        self.traverse_discounts(total, basket)
      end
    end

    options

  end

end




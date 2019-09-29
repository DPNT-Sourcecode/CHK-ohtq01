# noinspection RubyUnusedLocalVariable
class Checkout

  PRICES =
    {
      "A" => 50,
      "B" => 30,
      "C" => 20,
      "D" => 15,
      "E" => 40,
      "F" => 10,
      "G" => 20,
      "H" => 10,
      "I" => 35,
      "J" => 60,
      "K" => 70,
      "L" => 90,
      "M" => 15,
      "N" => 40,
      "O" => 10,
      "P" => 50,
      "Q" => 30,
      "R" => 50,
      "S" => 20,
      "T" => 20,
      "U" => 40,
      "V" => 50,
      "W" => 20,
      "X" => 17,
      "Y" => 20,
      "Z" => 21
    }

  STXYZ_DISCOUNTS = "STXYZ".each_char.to_a.repeated_combination(3).each.reduce({}) { |acc, val| acc[val.join] = 45; acc }

  DISCOUNTS =
    {
      "AAA" => 130,
      "AAAAA" => 200,
      "BB" => 45,
      "EEB" => 80,
      "FFF" => 20,
      "HHHHH" => 45,
      "HHHHHHHHHH" => 80,
      "KK" => 120,
      "NNNM" => 120,
      "PPPPP" => 200,
      "QQQ" => 80,
      "RRRQ" => 150,
      "UUUU" => 120,
      "VV" => 90,
      "VVV" => 130
    }.merge(STXYZ_DISCOUNTS)

  PRICING_CACHE = {}

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }
    return 0 if skus.empty?

    each_sku_count = Hash.new 0
    skus.each_char.sort.each do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    results = Checkout.traverse_discounts(Checkout::DISCOUNTS, 0, each_sku_count).sort_by do |discounted, basket|
      discounted + Checkout.basic_prices(basket)
    end

    if results.empty? then
      Checkout.basic_prices(each_sku_count)
    else
      results.first[0] + Checkout.basic_prices(results.first[1])
    end

  end

  def self.valid_sku?(sku)
    ("A".."Z").include? sku
  end

  def self.single_price(sku)
    PRICES[sku]
  end

  def self.discount(sku)
    DISCOUNTS[sku]
  end

  def self.basic_prices(basket)
    total = 0
    basket.each_pair do |k, v|
      total = total + (PRICES[k] * v)
    end
    total
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

  def self.traverse_discounts(all_discounts, total, basket)
    options = Checkout::PRICING_CACHE[basket]
    # puts options.inspect
    if options.nil? then
      successful_discounts = []
      applieds = all_discounts.map do |discount, val|
        # if this discount is applicable, remove the products and
        #   add the price of the discount to the total

        if new_basket = self.apply_discount(discount, basket) then
          successful_discounts.push [discount, val]
          [val, new_basket]
        else nil
        end
      end

      # drop all the invalid discounts we tried to apply and
      #   and then recurse
      options = applieds.reject{|v| v.nil?}.flat_map do |val, basket|
        if basket.empty? then
          [[val, basket]]
        else
          rest = self.traverse_discounts(successful_discounts, val, basket)
          if rest.empty? then
            [[val, basket]]
          else
            rest
          end
        end
      end
      # puts options
      options = options.group_by{ |val, basket| basket.hash }.map{|a| a[1].min_by(&:first)}
      # puts options.inspect
      Checkout::PRICING_CACHE[basket] = options
    end

    options.map do |count, basket|
      [total + count, basket]
    end

  end

end





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

    # results = Checkout.traverse_discounts(0, each_sku_count).sort_by do |discounted, basket|
    #   discounted + Checkout.basic_prices(basket)
    # end

    # if results.empty? then
    #   Checkout.basic_prices(each_sku_count)
    # else
    #   results.first.first
    # end

    results = Checkout.dfs_loop_discounts each_sku_count
    print results
    results.min

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

  def self.dfs_loop_discounts(basket)
    stack = [[0, basket]]
    results = []
    # best_total = Float::INFINITY

    while !stack.empty?
      current_total, this_basket = stack.pop
      DISCOUNTS.each do |discount, val|
        if new_basket = self.apply_discount(discount, basket) then
          if new_basket.empty? then
            results.push(current_total + val)
          else
            stack.push [current_total + val, new_basket]
          end
        end
      end
    end

    results
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
        rest = self.traverse_discounts(total, basket)
        if rest.empty? then
          [[total, basket]]
        else
          rest
        end
      end
    end

    options

  end

end



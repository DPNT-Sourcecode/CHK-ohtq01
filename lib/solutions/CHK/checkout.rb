# noinspection RubyUnusedLocalVariable
class Checkout

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| Checkout.valid_sku? sku }

    each_sku_count = Hash.new 0
    skus.each_char do |sku|
      each_sku_count[sku] = each_sku_count[sku] + 1
    end

    puts each_sku_count

    return 0
  end

  def self.valid_sku?(sku)
    ("A".."D").include? sku
  end

  def self.single_price(sku)
    {
      "A" => 50,
      "B" => 30,
      "C" => 20,
      "D" => 15
    }[sku]
  end

  def self.discount(sku)
    {
      "A" => [3, 150],
      "B" => [2, 45]
    }[sku]
  end

end




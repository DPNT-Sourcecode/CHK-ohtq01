# noinspection RubyUnusedLocalVariable
class Checkout

  def checkout(skus)
    return -1 unless skus.is_a? String
    return -1 unless skus.each_char.all? {|sku| valid_sku? sku }
    return 0
  end

  def self.valid_sku?(sku)
    case sku
      when "A"
        true
      when "B"
        true
      when "C"
        true
      when "D"
        true
    end
    false
  end

end




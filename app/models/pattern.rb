class Pattern < ActiveRecord::Base

  # returns array of indexes (e.g. [0,4,8,10,12])
  def pattern_indexes
    array = bits.to_s(2).chars.each_with_index.map do |value, index|
      index if value == '1'
    end
    array.compact
  end

  # feed this indexes (e.g. [0,4,8,10,12])
  def pattern_indexes=(indexes)
    pattern_bits = ('0' * step_count)
    indexes.each do |index|
      pattern_bits[index] = '1'
    end
    self.bits = pattern_bits.to_i(2)
  end 

  # returns an array of true or false for positions
  def pattern_bits
    bits.to_s(2).chars.collect{|x|x=='1'}
  end 

end

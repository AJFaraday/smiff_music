class Pattern < ActiveRecord::Base

  def Pattern.sound_init_params
    patterns = {}
    all.each do |pattern|
      patterns[pattern.name] = {
        steps: pattern.pattern_bits,
        sample: pattern.instrument_name
      }
    end
    {
      patterns: patterns
    }
  end

  def Pattern.to_hash
    result = {}
    all.each do |pattern|
      result[pattern.instrument_name] = pattern.to_hash
    end
    result
  end

  def to_hash
    {
      instrument_name: instrument_name,
      bits: pattern_bits,
      step_size: step_size,
      step_count: step_count
    }
  end


  # returns array of indexes (e.g. [0,4,8,10,12])
  def pattern_indexes
    self.bits ||= 0
    array = bits.to_s(2).rjust(self.step_count, '0').chars.each_with_index.map do |value, index|
      index if value == '1'
    end
    array.compact
  end

  # feed this indexes (e.g. [0,4,8,10,12])
  def pattern_indexes=(indexes)
    p_bits = ('0' * step_count)
    indexes.each do |index|
      p_bits[index] = '1'
    end
    self.bits = p_bits.rjust(self.step_count, '0').to_i(2)
  end 

  # returns an array of true or false for positions
  def pattern_bits
    str = bits.to_s(2)
    str = str.rjust(self.step_count, '0')
    str.chars.collect{|x|x=='1'}
  end 

end

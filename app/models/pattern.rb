class Pattern < ActiveRecord::Base

  after_initialize :set_default_bits

  after_save :modify_pattern_store

  def modify_pattern_store
    PatternStore.modify_hash(self)
  end

  def set_default_bits
    self.bits ||= 0
  end 

  def Pattern.sound_init_params
    patterns = {}
    all.each do |pattern|
      patterns[pattern.name] = pattern.to_hash
    end
    {
      patterns: patterns
    }
  end

  def Pattern.to_hash
    result = {}
    all.each do |pattern|
      result[pattern.name] = pattern.to_hash
    end
    result
  end

  def to_hash
    {
      steps: bits,
      sample: instrument_name,
      step_count: step_count,
      muted: muted
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

  # bits is stored as a blob. and retrieved as a a string
  # I want it to be an integer (so I can treat it as a bit mask)
  def bits
    super.to_i
  end

end

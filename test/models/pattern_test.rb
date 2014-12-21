require './test/test_helper'

class PatternTest < ActiveSupport::TestCase

  def test_pattern_indexes
    pattern = Pattern.new(
      # 10001000
      bits: 136,
      step_count: 8
    ) 
    assert_equal [0,4], pattern.pattern_indexes
  end  

  def test_pattern_indexes=
    pattern = Pattern.new(
      step_count: 8
    )
    pattern.pattern_indexes = [0,4]
    assert_equal [0,4], pattern.pattern_indexes  
    assert_equal 136, pattern.bits
  end

  def test_pattern_bits
    pattern = Pattern.new(
      # 10001000
      bits: 136,
      step_count: 8
    ) 
    assert_equal(
      [true,false,false,false,true,false,false,false],
      pattern.pattern_bits
    )
  end

  def test_to_hash
    pattern_hash = Pattern.first.to_hash
    [:instrument_name, :bits, :step_size, :step_count].each do |key|
      assert pattern_hash.keys.include? key
    end
    full_hash = Pattern.to_hash
    assert_includes full_hash.keys, Pattern.first.instrument_name
    assert_equal pattern_hash, full_hash[Pattern.first.name]
  end  

end

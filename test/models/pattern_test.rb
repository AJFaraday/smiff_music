require './test/test_helper'

class PatternTest < ActiveSupport::TestCase


  def test_set_default_bits
    pattern = Pattern.new
    assert_equal 0, pattern.bits
  end

  def test_sound_init_params
    params = Pattern.sound_init_params
    assert_equal [:patterns], params.keys
    patterns = params[:patterns]
    Pattern.all.each do |pattern|
      assert_includes patterns.keys, pattern.name
    end
  end

  def test_class_to_hash
    params = Pattern.to_hash
    Pattern.all.each do |pattern|
      assert_includes params.keys, pattern.name
    end
    pattern = Pattern.first
    assert_equal pattern.to_hash, params[pattern.name]
  end

  def test_instance_to_hash
    hash = Pattern.first.to_hash
    assert_equal(
      %i{ steps sample step_count muted},
      hash.keys
    )
    assert_instance_of Fixnum, hash[:steps]
    assert_instance_of String, hash[:sample]
    assert_instance_of Fixnum, hash[:step_count]
    assert_equal false, hash[:muted]
  end

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
    [:steps, :step_count, :muted].each do |key|
      assert_includes pattern_hash.keys, key
    end
    full_hash = Pattern.to_hash
    assert_includes full_hash.keys, Pattern.first.instrument_name
    assert_equal pattern_hash, full_hash[Pattern.first.name]
  end  

end

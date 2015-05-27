require './test/test_helper'

class PatternStoreTest < ActiveSupport::TestCase

  def setup
    Synth.rebuild
    Pattern.rebuild
  end

  def test_version_definition
    PatternStore.version = 9
    assert_equal 9, PatternStore.version
    assert_equal 9, PatternStore.hash['version']
    assert_equal '9', SystemSetting['pattern_version']
  end

  def test_build_hash
    hash = PatternStore.build_hash
    assert_equal SystemSetting['bpm'], hash['bpm']
    assert_equal PatternStore.version, hash['version']
    assert_instance_of Hash, hash['patterns']['kick']
    assert_equal(
      %i{steps sample step_count muted},
      hash['patterns']['kick'].keys
    )
  end

  def test_modify_hash_for_pattern
    hash = Hash.new(PatternStore.hash)
    pattern = Pattern.find_by_name('snare')
    pattern.update_attribute(:pattern_indexes, [4, 7, 8])
    assert_not_equal(hash, PatternStore.hash)
    assert_not_equal(hash['patterns']['snare'], PatternStore.hash['patterns']['snare'])
  end

  def test_modify_hash_for_bpm
    hash = Hash.new(PatternStore.hash)
    PatternStore.modify_hash('bpm', 140)
    assert_not_equal(hash, PatternStore.hash)
    assert_not_equal(hash['bpm'], PatternStore.hash['bpm'])
  end

end
require './test/test_helper'

class SynthTest < ActiveSupport::TestCase

  def setup
    # there was some load-order issues in creating this
    PatternStore.hash
  end


  def test_new_synth_has_patterns_and_pitches
      synth = Synth.create!(
        name: 'synth',
        osc_type: 'sine',
        attack_time: 0.1,
        decay_time: 0.1,
        sustain_level: 0.1,
        release_time: 0.1,
        step_size: 16,
        step_count: 4,
        min_note: 5,
        max_note: 10
      )

    assert_kind_of Pattern, synth.patterns.note_on
    assert_equal 'note_on', synth.patterns.note_on.purpose

    assert_kind_of Pattern, synth.patterns.note_off
    assert_equal 'note_off', synth.patterns.note_off.purpose

    assert_equal [nil,nil,nil,nil], synth.pitches

    assert_equal 6, synth.range
  end


end

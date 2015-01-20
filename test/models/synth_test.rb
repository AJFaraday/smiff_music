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

  def test_pitch_at_step
    synth = Synth.find(1)
    assert_nil synth.pitches[0]
    assert_nil synth.pitches[7]
    assert_nil synth.pitches[15]

    synth.pitches = [60,nil,nil,nil,62,nil,nil,nil]
    # directly declared
    assert_equal 60, synth.pitch_at_step(0)
    assert_equal 62, synth.pitch_at_step(4)
    # following declared pitch
    assert_equal 60, synth.pitch_at_step(2)
    assert_equal 62, synth.pitch_at_step(6)
  end

  def test_active_at_step
    synth = Synth.find(1)
    # both patterns are empty
    refute synth.active_at_step(0)
    refute synth.active_at_step(4)
    refute synth.active_at_step(8)

    synth.patterns.note_on.update_attribute(:pattern_indexes, [0])
    # all on (it doesn't end)
    assert synth.active_at_step(0)
    assert synth.active_at_step(4)
    assert synth.active_at_step(8)

    synth.patterns.note_off.update_attribute(:pattern_indexes, [2])
    # on for the first 2 beats
    assert synth.active_at_step(0)
    refute synth.active_at_step(4)
    refute synth.active_at_step(8)
  end

  def test_instance_sound_init_params
    synth = Synth.find(1)
    params = synth.sound_init_params

    assert_equal synth.osc_type, params[:osc_type]
    assert_equal synth.attack_time, params[:attack_time]
    assert_equal synth.decay_time, params[:decay_time]
    assert_equal synth.sustain_level, params[:sustain_level]
    assert_equal synth.release_time, params[:release_time]
    assert_equal synth.muted, params[:muted]
    assert_equal(
      synth.patterns.note_on.bits,
      params[:note_on_steps]
    )
    assert_equal(
      synth.patterns.note_off.bits,
      params[:note_off_steps]
    )
    assert_equal synth.step_count, params[:step_count]
    assert_equal synth.pitches, params[:pitches]
  end

  def test_class_sound_init_params
    params = Synth.sound_init_params
    assert_kind_of Hash, params
    assert_kind_of Hash, params[:synths]
    assert_kind_of Hash, params[:synths]['sine']

    synth = Synth.find(1)
    assert_equal synth.sound_init_params, params[:synths]['sine']
  end

  def test_to_hash
    synth = Synth.find(1)
    params = synth.to_hash

    assert_equal synth.muted, params[:muted]
    assert_equal(
      synth.patterns.note_on.bits,
      params[:note_on_steps]
    )
    assert_equal(
      synth.patterns.note_off.bits,
      params[:note_off_steps]
    )
    assert_equal synth.pitches, params[:pitches]
  end

  #
  # This produces the data for the envelope graph
  #
=begin
  attack_time: 0.1
  decay_time: 0.3
  sustain_level: 0.3
  release_time: 0.5
=end
  def test_chart_data
    data = Synth.find(1).chart_data
    assert_equal(
      [0,1,nil,nil,0.3,nil,nil,nil,nil,0.3,nil,nil,nil,nil,0],
      data
    )

  end

  # this is the data required to draw the graph, required by chart.js
  def test_chart_data_full
    synth = Synth.find(1)
    data = synth.chart_data_full
    assert_kind_of Array, data[:labels]
    data[:labels].each do |label|
      assert_equal '', label
    end
    assert_kind_of Array, data[:datasets]
    assert_equal 1, data[:datasets].length
    assert_equal "rgba(220,220,220,0.2)", data[:datasets][0][:fillColor]
    assert_equal "rgba(220,220,220,1)", data[:datasets][0][:strokeColor]
    assert_equal synth.chart_data, data[:datasets][0][:data]
  end


end

require './test/test_helper'

class SynthTest < ActiveSupport::TestCase

  def setup
    InMemory.rebuild
    # there was some load-order issues in creating this
    PatternStore.hash
  end


  def test_new_synth_has_patterns_and_pitches
    synth = Synth.create!(
      name: 'synth',
      constructor: 'SimpleSynth',
      waveshape: 'sine',
      volume: 50,
      attack_time: 0.1,
      decay_time: 0.1,
      sustain_level: 0.1,
      release_time: 0.1,
      step_size: 16,
      step_count: 4,
      min_note: 5,
      max_note: 10
    )

    assert_kind_of Pattern, synth.note_on_pattern
    assert_equal 'note_on', synth.note_on_pattern.purpose

    assert_kind_of Pattern, synth.note_off_pattern
    assert_equal 'note_off', synth.note_off_pattern.purpose

    assert_equal [nil,nil,nil,nil], synth.pitches

    assert_equal 6, synth.range
  end

  def test_pitch_at_step
    synth = Synth.find_by_name('sarah')
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
    synth = Synth.find_by_name('sarah')
    # both patterns are empty
    refute synth.active_at_step(0)
    refute synth.active_at_step(4)
    refute synth.active_at_step(8)

    synth.note_on_pattern.update_attribute(:pattern_indexes, [0])
    # all on (it doesn't end)
    assert synth.active_at_step(0)
    assert synth.active_at_step(4)
    assert synth.active_at_step(8)

    synth.note_off_pattern.update_attribute(:pattern_indexes, [2])
    # on for the first 2 beats
    assert synth.active_at_step(0)
    refute synth.active_at_step(4)
    refute synth.active_at_step(8)
  end

  def test_instance_sound_init_params
    synth = Synth.find_by_name('sarah')
    params = synth.sound_init_params

    assert_equal synth.waveshape, params[:waveshape]
    assert_equal synth.attack_time, params[:attack_time]
    assert_equal synth.decay_time, params[:decay_time]
    assert_equal synth.sustain_level, params[:sustain_level]
    assert_equal synth.release_time, params[:release_time]
    assert_equal synth.muted, params[:muted]
    assert_equal(
      synth.note_on_pattern.bits,
      params[:note_on_steps]
    )
    assert_equal(
      synth.note_off_pattern.bits,
      params[:note_off_steps]
    )
    assert_equal synth.step_count, params[:step_count]
    assert_equal synth.pitches, params[:pitches]
  end

  def test_class_sound_init_params
    params = Synth.sound_init_params
    assert_kind_of Hash, params
    assert_kind_of Hash, params[:synths]
    assert_kind_of Hash, params[:synths]['sarah']

    synth = Synth.find_by_name('sarah')
    assert_equal synth.sound_init_params, params[:synths]['sarah']
  end

  def test_to_hash
    synth = Synth.find_by_name('sarah')
    params = synth.to_hash

    assert_equal synth.muted, params[:muted]
    assert_equal(
      synth.note_on_pattern.bits,
      params[:note_on_steps]
    )
    assert_equal(
      synth.note_off_pattern.bits,
      params[:note_off_steps]
    )
    assert_equal synth.pitches, params[:pitches]
  end

  #
  # back-end method to add a note
  #
  # The result is a change to the note_on and note_off patterns
  # and an entry in to the pitch array
  #
  # add_note(pitch, start_index, length)
  #
  #
  # for an empty synth pattern
  #
  #       #   #   #   #
  #           |  |
  # pitch ----#-----------
  # on    ----#-----------
  # off   -------#--------
  #
  def test_add_note_simple
    synth = Synth.find_by_name('sarah')

    synth.add_note(60,4,4)
    assert_equal 60, synth.pitches[4]
    assert_equal [4], synth.note_on_pattern.pattern_indexes
    assert_equal [7], synth.note_off_pattern.pattern_indexes
  end

  #
  #       #   #   #   #
  #           |  |
  # pitch ----1-----------
  # on    ----#-----------
  # off   -------#--------
  #             |  |
  # pitch ----1-2---------
  # on    ----#-#---------
  # off   -----#---#------
  #
  # note: it does creates noteoff for previous note
  #
  def test_add_note_cutting_across
    synth = Synth.find_by_name('sarah')

    synth.add_note(60,4,4)
    synth.add_note(62,6,4)

    assert_equal 60, synth.pitches[4]
    assert_equal 62, synth.pitches[6]
    assert_equal [4, 6], synth.note_on_pattern.pattern_indexes
    assert_equal [5, 9], synth.note_off_pattern.pattern_indexes
  end

  #       #   #   #   #
  #       |       |
  # pitch 1---------------
  # on    #---------------
  # off   --------#-------
  #           ||
  # pitch 1---2--1--------
  # on    #---#-#---------
  # off   ---#-#--#-------
  #
  def test_add_note_within_other_note
    synth = Synth.find_by_name('sarah')
    synth.add_note(60,0,9)
    assert_equal 60, synth.pitches[0]
    assert_equal [0], synth.note_on_pattern.pattern_indexes
    assert_equal [8], synth.note_off_pattern.pattern_indexes

    synth.add_note(62,4,2)
    assert_equal 60, synth.pitches[0]
    assert_equal 62, synth.pitches[4]
    assert_equal 60, synth.pitches[6]
    assert_equal [0,4,6], synth.note_on_pattern.pattern_indexes
    assert_equal [3,5,8], synth.note_off_pattern.pattern_indexes
  end



  # back-end method to remove a note
  #
  # remove_note(start_step)
  #
  #       #   #   #   #
  #           |   |
  # pitch ----#-----------
  # on    ----#-----------
  # off   -------#--------
  def test_remove_note_simple
    synth = Synth.find_by_name('sarah')

    synth.add_note(60,4,4)
    assert_equal 60, synth.pitches[4]
    assert_equal [4], synth.note_on_pattern.pattern_indexes
    assert_equal [7], synth.note_off_pattern.pattern_indexes


    synth.remove_note(4)
    assert_equal nil, synth.pitches[4]
    assert_equal [], synth.note_on_pattern.pattern_indexes
    assert_equal [], synth.note_off_pattern.pattern_indexes
  end


  #       #   #   #   #
  #      +    |   |
  # pitch ----#-----------
  # on    ----#-----------
  # off   --------#-------
  #      +      |   |      (legato, implemented later)
  # pitch ----#-#---------
  # on    ----#-#---------
  # off   ----------#-----
  #      -      |
  # pitch ----#-----------
  # on    ----#-----------
  # off   -----#----------
  #
  #
  def test_remove_note_add_missing_note_off
    synth = Synth.find_by_name('sarah')

    synth.add_note(60,4,4)
    synth.add_note(62,6,8)

    assert_equal 60, synth.pitches[4]
    assert_equal 62, synth.pitches[6]
    assert_equal [4, 6], synth.note_on_pattern.pattern_indexes

    synth.note_off_pattern.update_attribute(:pattern_indexes, [10])

    synth.remove_note(6)
    assert_equal 60, synth.pitches[4]
    assert_equal nil, synth.pitches[6]
    assert_equal [4], synth.note_on_pattern.pattern_indexes
    assert_equal [5], synth.note_off_pattern.pattern_indexes
  end

end




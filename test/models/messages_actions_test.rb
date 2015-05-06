require './test/test_helper'

# testing Messages::Actions
class MessagesActionsTest < ActiveSupport::TestCase

  def setup
    PatternStore.hash = nil
  end

  # this method is used to fix the rubbish input from list regexes
  def test_munge_list
    # single string is converted to one-member array
    assert_equal(
      ['this'],
      Messages::Actions.munge_list('this')
    )

    assert_equal(
      ['this', 'that', 'theother'],
      Messages::Actions.munge_list(['this', ', that', 'that', ' and theother'])
    )
  end

  def test_pattern_not_found
    result = Messages::Actions.pattern_not_found(['timpani', 'guitar'])
    assert_equal 'failure', result[:response]
    assert_equal(
      "Sorry, I can't find any patterns named timpani and guitar",
      result[:display]
    )
  end


  def test_add_steps_one_step
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['3']
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now playing kick on step 3", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [2],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_add_steps_out_of_range
    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['92', '93', '94']
      }
    )
    assert_equal 'failure', result[:response]
    assert_equal(
      "Sorry, I can't add these steps because some are out of range (1 to 32)",
      result[:display]
    )
  end

  def test_add_steps_no_pattern
    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'tabla',
        'steps' => ['3']
      }
    )
    assert_equal 'failure', result[:response]
    assert_equal "Sorry, I can't find any patterns named tabla", result[:display]
  end

  def test_add_steps_list
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['3', '9', '14']
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now playing kick on steps 3, 9 and 14", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [2, 8, 13],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_add_steps_block
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'kick',
        'start_step' => '3',
        'end_step' => '7'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now playing kick on steps 3, 4, 5, 6 and 7", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [2, 3, 4, 5, 6],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_add_steps_block_with_skipping
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.add_steps(
      {
        'pattern_name' => 'kick',
        'start_step' => '3',
        'end_step' => '7',
        'block_size' => '1'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now playing kick on steps 3, 5 and 7", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [2, 4, 6],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_clear_all
    Synth.first.note_on.update_attribute :pattern_indexes, [0, 1, 2]
    Synth.last.note_on.update_attribute :pattern_indexes, [0, 1, 2]
    Synth.first.note_off.update_attribute :pattern_indexes, [4]
    Synth.last.note_off.update_attribute :pattern_indexes, [4]
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2]
    Pattern.last.update_attribute :pattern_indexes, [0, 1, 2]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_all({'group' => ['']})
    assert_equal 'success', result[:response]
    assert_equal("I've cleared all of the patterns.", result[:display])

    assert_equal 0, PatternStore.hash['synths']['sine'][:note_on_steps]
    assert_equal 0, PatternStore.hash['synths']['square'][:note_on_steps]
    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_clear_all_drums
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2]
    Pattern.last.update_attribute :pattern_indexes, [0, 1, 2]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_all({'group' => [' drums']})
    assert_equal 'success', result[:response]
    assert_equal("I've cleared all of the drum patterns.", result[:display])

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_clear_all_synths
    Synth.first.note_on.update_attribute :pattern_indexes, [0, 1, 2]
    Synth.last.note_on.update_attribute :pattern_indexes, [0, 1, 2]
    Synth.first.note_off.update_attribute :pattern_indexes, [4]
    Synth.last.note_off.update_attribute :pattern_indexes, [4]

    result = Messages::Actions.clear_all({'group' => [' synths']})
    assert_equal 'success', result[:response]
    assert_equal("I've cleared all of the synth patterns.", result[:display])

    assert_equal 0, PatternStore.hash['synths']['sine'][:note_on_steps]
    assert_equal 0, PatternStore.hash['synths']['square'][:note_on_steps]
  end


  def test_clear_patterns_one_drum
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_patterns({'pattern_names' => ['kick']})
    assert_equal 'success', result[:response]
    assert_equal("I've cleared the kick pattern", result[:display])

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_clear_patterns_list
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_patterns({'pattern_names' => ['kick', 'snare', 'hihat']})
    assert_equal 'success', result[:response]
    assert_equal("I've cleared the kick, snare and hihat patterns", result[:display])

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_clear_patterns_no_pattern
    result = Messages::Actions.clear_patterns({'pattern_names' => ['dog', 'cat', 'fridge']})
    assert_equal 'failure', result[:response]
    assert_equal "Sorry, I can't find any patterns named dog, cat and fridge", result[:display]
  end

  def test_drum_clear_steps_one
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['1']
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "Now no longer playing kick on step 1",
      result[:display]
    )
    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [1, 2, 3, 4, 5, 6],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end


  def test_drum_clear_steps_out_of_range
    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['92', '93', '94']
      }
    )
    assert_equal 'failure', result[:response]
    assert_equal(
      "Sorry, I can't clear these steps because some are out of range (1 to 32)",
      result[:display]
    )
  end

  def test_drum_clear_steps_no_pattern
    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'tabla',
        'steps' => ['3']
      }
    )
    assert_equal 'failure', result[:response]
    assert_equal "Sorry, I can't find any patterns named tabla", result[:display]
  end

  def test_drum_clear_steps_list
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'kick',
        'steps' => ['3', '5', '6']
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now no longer playing kick on steps 3, 5 and 6", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [0, 1, 3, 6],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end


  def test_drum_clear_steps_block
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'kick',
        'start_step' => '2',
        'end_step' => '4'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now no longer playing kick on steps 2, 3 and 4", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [0, 4, 5, 6],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_drum_clear_steps_block_with_skipping
    Pattern.first.update_attribute :pattern_indexes, [0, 1, 2, 3, 4, 5, 6]
    kick_bits = PatternStore.hash['patterns']['kick'][:steps]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'kick',
        'start_step' => '3',
        'end_step' => '7',
        'block_size' => '1'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal "Now no longer playing kick on steps 3, 5 and 7", result[:display]

    pattern = Pattern.find_by_name('kick')
    assert_equal(
      [0, 1, 3, 5],
      pattern.pattern_indexes
    )

    assert_not_equal kick_bits, PatternStore.hash['patterns']['kick'][:steps]
  end

  def test_list_drums
    result = Messages::Actions.list_drums({})
    assert_equal 'success', result[:response]
    assert_equal(
      "* kick
* snare
* hihat
* crash
* tom1
* tom2
* tom3
",
      result[:display]
    )
  end

  def test_list_synths
    result = Messages::Actions.list_synths({})
    assert_equal 'success', result[:response]
    assert_equal(
      "* sine
* square
",
      result[:display]
    )
  end

  def test_mute_one_pattern
    pattern = Pattern.where(:name => 'kick').first
    pattern.update_attribute(:muted, false)
    refute PatternStore.hash['patterns']['kick'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['kick'],
        'mode' => 'mute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've muted the kick pattern",
      result[:display]
    )

    pattern.reload
    assert_equal true, pattern.muted
    assert PatternStore.hash['patterns']['kick'][:muted]
  end

  def test_mute_one_synth
    synth = Synth.where(:name => 'sine').first
    synth.update_attribute(:muted, false)
    refute PatternStore.hash['synths']['sine'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['sine'],
        'mode' => 'mute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've muted the sine pattern",
      result[:display]
    )

    synth.reload
    assert_equal true, synth.muted
    assert PatternStore.hash['synths']['sine'][:muted]
  end

  def test_mute_list
    Pattern.first.update_attribute(:muted, false)
    patterns = Pattern.where(:name => ['kick', 'snare', 'hihat'])
    refute PatternStore.hash['patterns']['kick'][:muted]
    synth = Synth.where(:name => 'sine').first
    synth.update_attribute(:muted, false)
    refute PatternStore.hash['synths']['sine'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['kick', 'snare', 'hihat', 'sine'],
        'mode' => 'mute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've muted the kick, snare, hihat and sine patterns",
      result[:display]
    )

    patterns.each do |pattern|
      assert_equal true, pattern.muted
    end

    assert PatternStore.hash['patterns']['kick'][:muted]
    synth.reload
    assert_equal true, synth.muted
    assert PatternStore.hash['synths']['sine'][:muted]

  end

  def test_unmute_one_drum
    pattern = Pattern.where(:name => 'kick').first
    pattern.update_attribute(:muted, true)
    assert PatternStore.hash['patterns']['kick'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['kick'],
        'mode' => 'unmute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've unmuted the kick pattern",
      result[:display]
    )

    pattern.reload
    assert_equal false, pattern.muted
    refute PatternStore.hash['patterns']['kick'][:muted]
  end

  def test_unmute_one_synth
    synth = Synth.where(:name => 'sine').first
    synth.update_attribute(:muted, true)
    assert PatternStore.hash['synths']['sine'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['sine'],
        'mode' => 'unmute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've unmuted the sine pattern",
      result[:display]
    )

    synth.reload
    refute synth.muted
    refute PatternStore.hash['synths']['sine'][:muted]
  end


  def test_unmute_list
    patterns = Pattern.where(:name => ['kick', 'snare', 'hihat'])
    patterns.each { |pattern| pattern.update_attribute :muted, true }
    assert PatternStore.hash['patterns']['kick'][:muted]
    synth = Synth.where(:name => 'sine').first
    synth.update_attribute(:muted, true)
    assert PatternStore.hash['synths']['sine'][:muted]

    result = Messages::Actions.mute_unmute(
      {
        'pattern_names' => ['kick', 'snare', 'hihat', 'sine'],
        'mode' => 'unmute'
      }
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "I've unmuted the kick, snare, hihat and sine patterns",
      result[:display]
    )

    patterns.each do |pattern|
      pattern.reload
      assert_equal false, pattern.muted
    end
    refute PatternStore.hash['patterns']['kick'][:muted]
    synth.reload
    refute synth.muted
    refute PatternStore.hash['synths']['sine'][:muted]
  end

  def test_set_speed
    result = Messages::Actions.set_speed(
      {'bpm' => ['150']}
    )
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is now 150 beats per minute",
      result[:display]
    )
    assert_equal '150', SystemSetting['bpm']
    assert_equal 150, PatternStore.hash['bpm']
  end

  def test_set_speed_too_fast
    result = Messages::Actions.set_speed(
      {'bpm' => ['900']}
    )
    assert_equal 'failure', result[:response]
    assert_equal(
      "Sorry, the speed you asked for (900 bpm) is more than the maximum: 200 bpm",
      result[:display]
    )
  end

  def test_set_speed_too_slow
    result = Messages::Actions.set_speed(
      {'bpm' => ['1']}
    )
    assert_equal 'failure', result[:response]
    assert_equal(
      "Sorry, the speed you asked for (1 bpm) is less than the minimum: 60 bpm",
      result[:display]
    )
  end


  def test_speed_up
    SystemSetting['bpm'] = 120
    result = Messages::Actions.speed_up({})
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is now 125 beats per minute",
      result[:display]
    )
    assert_equal '125', SystemSetting['bpm']
    assert_equal '125', PatternStore.hash['bpm']

    result = Messages::Actions.speed_up({})
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is now 130 beats per minute",
      result[:display]
    )
    assert_equal '130', SystemSetting['bpm']
    assert_equal '130', PatternStore.hash['bpm']

  end

  def test_speed_down
    SystemSetting['bpm'] = 120
    result = Messages::Actions.speed_down({})
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is now 115 beats per minute",
      result[:display]
    )
    assert_equal '115', SystemSetting['bpm']
    assert_equal '115', PatternStore.hash['bpm']

    result = Messages::Actions.speed_down({})
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is now 110 beats per minute",
      result[:display]
    )
    assert_equal '110', SystemSetting['bpm']
    assert_equal '110', PatternStore.hash['bpm']
  end

  def test_show_speed
    SystemSetting['bpm'] = 120
    result = Messages::Actions.show_speed({})
    assert_equal 'success', result[:response]
    assert_equal(
      "The speed is 120 beats per minute",
      result[:display]
    )
  end

  def test_show_one_pattern
    Pattern.find_by_name('kick').update_attributes(bits: 0)
    PatternStore.hash = nil
    result = Messages::Actions.show_patterns(
      {'pattern_names' => ['kick']}
    )
    display = "-----1---5---9---13--17--21--25--29--
kick---------------------------------"
    assert_includes(
      result[:display],
      display
    )
  end

  def test_show_list
    Pattern.find_by_name('kick').update_attributes(bits: 0)
    PatternStore.hash = nil
    result = Messages::Actions.show_patterns(
      {'pattern_names' => ['kick', 'snare', 'hihat']}
    )
    display = "------1---5---9---13--17--21--25--29--
kick---------------------------------- 
snare--------------------------------- 
hihat--------------------------------- 
"
    assert_equal(
      display,
      result[:display]
    )
  end

  def test_show_one_synth
    synth = Synth.find_by_name('sine')
    synth.add_note(60, 5, 4)
    result = Messages::Actions.show_patterns(
      {'pattern_names' => ['sine']}
    )
    display = "-----1---5---9---13--17--21--25--29--
C 5----------------------------------
B 4----------------------------------
A# 4---------------------------------
A 4----------------------------------
G# 4---------------------------------
G 4----------------------------------
F# 4---------------------------------
F 4----------------------------------
E 4----------------------------------
D# 4---------------------------------
D 4----------------------------------
C# 4---------------------------------
C 4-------####-----------------------
B 3----------------------------------
A# 3---------------------------------"
    assert_includes(
      result[:display],
      display
    )
  end

  def test_show_all
    Pattern.find_by_name('kick').update_attributes(bits: 0)
    PatternStore.hash = nil
    result = Messages::Actions.show_all_drums({})
    assert_equal('success', result[:response])
    display = "------1---5---9---13--17--21--25--29--
kick---------------------------------- 
snare--------------------------------- 
hihat--------------------------------- 
crash--------------------------------- 
tom1---------------------------------- 
tom2---------------------------------- 
tom3---------------------------------- 
"
    assert_equal(
      display,
      result[:display]
    )
  end

  def test_mute_all

    result = Messages::Actions.mute_unmute_all({'mode' => 'mute', 'group' => ' drums'})
    assert_equal('success', result[:response])
    assert_equal(
      I18n.t('actions.mute_unmute_all.success', action: 'muted', group: ' drum'),
      result[:display]
    )
    Pattern.all.each { |p| assert p.muted }
    assert PatternStore.hash['patterns']['kick'][:muted]
  end

  def test_unmute_all
    Pattern.first.update_attribute(:muted, true)
    result = Messages::Actions.mute_unmute_all({'mode' => 'unmute', 'group' => ' drums'})

    assert_equal('success', result[:response])
    assert_equal(
      I18n.t('actions.mute_unmute_all.success', action: 'unmuted', group: ' drum'),
      result[:display]
    )
    Pattern.all.each { |p| refute p.muted }
    refute PatternStore.hash['patterns']['kick'][:muted]
  end

  def test_show_includes_mute_info
    Pattern.update_all(:muted => false)
    result = Messages::Actions.show_all_drums({})
    refute result[:display].include?('(muted)')
    Pattern.update_all(:muted => true)
    result = Messages::Actions.show_all_drums({})
    assert result[:display].include?('(muted)')
  end

  def test_set_note_length
    result = Messages::Actions.set_note_length(
      {
        'note_steps' => ['4']
      }
    )
    assert_equal(
      {
        response: 'success',
        display: "I've set the note length to 4 steps. Any notes you add now will be 4 steps long.",
        session: {note_steps: 4}
      },
      result
    )
  end

  def test_set_note_length_too_short
    result = Messages::Actions.set_note_length(
      {
        'note_steps' => ['0']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, I wasn't able to set the note length to 0. That's too short, it must be at least 1 step."
      },
      result
    )
  end

  def test_set_note_length_too_long
    result = Messages::Actions.set_note_length(
      {
        'note_steps' => ['99']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, I wasn't able to set the note length to 99. That's too long, the maximum is 16 steps."
      },
      result
    )
  end

  def test_set_synth
    result = Messages::Actions.set_synth(
      {'synth' => ['sine']}
    )
    assert_equal(
      {
        response: 'success',
        display: "I've set the current synth to sine, any notes you add will be added to sine",
        session: {synth: 'sine'}
      },
      result
    )
  end

  def test_set_synth_not_found
    result = Messages::Actions.set_synth(
      {'synth' => ['super']}
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, I can't find a synth named 'super'"
      },
      result
    )
  end

  def test_add_notes_not_found
    result = Messages::Actions.add_notes(
      {'synth' => ['super']}
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, I can't find any patterns named super"
      },
      result
    )
  end

  def test_add_notes_single
    synth = Synth.find_by_name('sine')
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: "I'll now play C 4 from step 1 on the sine synth"
      },
      result
    )
    synth.reload
    assert_equal [0], synth.note_on.pattern_indexes
    assert_equal [1], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]
  end

  def test_add_notes_single_too_high
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c9',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, that's too high for sine to play, it only goes up to C 5."
      },
      result
    )
  end

  def test_add_notes_single_too_low
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c1',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, that's too low for sine to play, it only goes down to A# 3"
      },
      result
    )
  end


  def test_add_notes_list
    synth = Synth.find_by_name('sine')
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4, d4, e4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: "I've added this melody to sine from step 1."
      },
      result
    )
    synth.reload
    assert_equal [0, 2, 4], synth.note_on.pattern_indexes
    assert_equal [1, 3, 5], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]
    assert_equal 62, synth.pitches[2]
    assert_equal 64, synth.pitches[4]
  end

  def test_add_notes_list_skipping
    synth = Synth.find_by_name('sine')
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4, d4, e4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2',
        'block_size' => '1'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: "I've added this melody to sine from step 1."
      },
      result
    )
    synth.reload
    assert_equal [0, 3, 6], synth.note_on.pattern_indexes
    assert_equal [1, 4, 7], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]
    assert_equal 62, synth.pitches[3]
    assert_equal 64, synth.pitches[6]
  end


  def test_add_notes_list_too_high
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4, c9, d4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, that's too high for sine to play, it only goes up to C 5."
      },
      result
    )
  end

  def test_add_notes_list_too_low
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4, c1, d4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '2'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, that's too low for sine to play, it only goes down to A# 3"
      },
      result
    )
  end

  def test_add_notes_list_too_long
    result = Messages::Actions.add_notes(
      {
        'note_names' => 'c4, d4',
        'start_step' => '1',
        'synth' => 'sine',
        'note_steps' => '32'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: "Sorry, that would spill off the end of the pattern. sine only has 32 steps."
      },
      result
    )
  end

  def test_synth_clear_one_step
    synth = Synth.find_by_name('sine')
    synth.add_note(60, 0, 4)
    assert_equal [0], synth.note_on.pattern_indexes
    assert_equal [3], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'steps' => ['2']
      }
    )
    assert_equal(
      {
        response: 'success',
        display: I18n.t(
          "actions.clear_steps.success.one",
          name: synth.name,
          steps: '2'
        )
      },
      result
    )
    synth.reload
    synth.note_on.reload
    synth.note_off.reload
    assert_equal [], synth.note_on.pattern_indexes
    assert_equal [], synth.note_off.pattern_indexes
    assert_equal nil, synth.pitches[0]
  end

  def test_synth_clear_list_of_steps
    synth = Synth.find_by_name('sine')
    synth.add_note(60, 0, 4)
    synth.add_note(68, 8, 4)
    assert_equal [0, 8], synth.note_on.pattern_indexes
    assert_equal [3, 11], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]
    assert_equal 68, synth.pitches[8]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'steps' => ['2 and 10']
      }
    )
    assert_equal(
      {
        response: 'success',
        display: I18n.t(
          "actions.clear_steps.success.other",
          name: synth.name,
          steps: ['2', '10'].to_sentence(last_word_connector: ' or ')
        )
      },
      result
    )
    synth.reload
    synth.note_on.reload
    synth.note_off.reload
    assert_equal [], synth.note_on.pattern_indexes
    assert_equal [], synth.note_off.pattern_indexes
    assert_equal nil, synth.pitches[0]
    assert_equal nil, synth.pitches[8]
  end

  def test_synth_clear_one_step_none_to_remove
    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'steps' => ['2']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t(
          "actions.clear_steps.no_steps_to_remove.one",
          name: 'sine',
          steps: '2'
        )
      },
      result
    )
  end

  def test_synth_clear_list_of_steps_none_to_remove
    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'steps' => ['2 and 10']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t(
          "actions.clear_steps.no_steps_to_remove.other",
          name: 'sine',
          steps: ['2', '10'].to_sentence(last_word_connector: ' and ')
        )
      },
      result
    )
  end

  def test_synth_clear_block
    synth = Synth.find_by_name('sine')
    synth.add_note(60, 0, 8)
    assert_equal [0], synth.note_on.pattern_indexes
    assert_equal [7], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'start_step' => '3',
        'end_step' => '5'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: I18n.t(
          "actions.clear_steps.success.other",
          name: synth.name,
          steps: ['3', '4', '5'].to_sentence(last_word_connector: ' and ')
        )
      },
      result
    )
    synth.reload
    synth.note_on.reload
    synth.note_off.reload
    assert_equal [0, 5], synth.note_on.pattern_indexes
    assert_equal [1, 7], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]
    assert_equal 60, synth.pitches[5]
  end

  def test_synth_clear_block_skipping
    synth = Synth.find_by_name('sine')
    synth.add_note(60, 0, 8)
    assert_equal [0], synth.note_on.pattern_indexes
    assert_equal [7], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[0]

    result = Messages::Actions.clear_steps(
      {
        'pattern_name' => 'sine',
        'start_step' => '1',
        'end_step' => '8',
        'block_size' => '2'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: I18n.t(
          "actions.clear_steps.success.other",
          name: synth.name,
          steps: ['1', '4', '7'].to_sentence(last_word_connector: ' and ')
        )
      },
      result
    )
    synth.reload
    synth.note_on.reload
    synth.note_off.reload
    assert_equal [1, 4], synth.note_on.pattern_indexes
    assert_equal [2, 5, 7], synth.note_off.pattern_indexes
    assert_equal 60, synth.pitches[1]
    assert_equal 60, synth.pitches[4]
  end

  def test_describe_synth
    synth = Synth.find_by_name('sine')

    result = Messages::Actions.describe_synth(
      {
        'synth' => ['sine']
      }
    )
    assert_equal(
      {
        response: 'success',
        display: synth.description
      },
      result
    )
  end

  def test_describe_failed
    synth = Synth.find_by_name('sine')

    result = Messages::Actions.describe_synth(
      {
        'synth' => ['nope']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t('messages.errors.synth_not_found', synth: 'nope')
      },
      result
    )
  end


  def test_list_params_synth
    synth = Synth.find_by_name('sine')

    result = Messages::Actions.list_params(
      {
        'synth' => ['sine']
      }
    )
    assert_equal(
      {
        response: 'success',
        display: synth.parameter_list
      },
      result
    )
  end

  def test_list_params_failed
    synth = Synth.find_by_name('sine')

    result = Messages::Actions.list_params(
      {
        'synth' => ['nope']
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t('messages.errors.synth_not_found', synth: 'nope')
      },
      result
    )
  end

  def test_set_param_synth
    synth = Synth.find_by_name('sine')

    result = Messages::Actions.set_param(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '50'
      }
    )
    assert_equal(
      {
        response: 'success',
        display: I18n.t(
          'actions.set_param.success',
          synth: 'sine',
          param: 'volume',
          value: '50'
        )
      },
      result
    )

    synth.reload
    assert_equal '50', synth.volume
  end

  def test_set_param_synth_not_found
    result = Messages::Actions.set_param(
      {
        'synth' => 'nope',
        'parameter' => 'volume',
        'value' => '50'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t('messages.errors.synth_not_found', synth: 'nope')
      },
      result
    )
  end

  def test_set_param_parameter_not_found
    result = Messages::Actions.set_param(
      {
        'synth' => 'sine',
        'parameter' => 'awesomeness',
        'value' => '50'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t('messages.errors.parameter_not_found',
                        synth: 'sine', parameter: 'awesomeness')
      },
      result
    )
  end

  def test_set_param_value_too_high
    result = Messages::Actions.set_param(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '500'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t(
          'actions.set_param.validation_failed',
          synth: 'sine',
          param: 'volume',
          value: '500',
          error: 'must be less than or equal to 100'
        )
      },
      result
    )
  end

  def test_set_param_value_too_low
    result = Messages::Actions.set_param(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '-1'
      }
    )
    assert_equal(
      {
        response: 'failure',
        display: I18n.t(
          'actions.set_param.validation_failed',
          synth: 'sine',
          param: 'volume',
          value: '-1',
          error: 'must be greater than or equal to 0'
        )
      },
      result
    )
  end
  
  def test_play
    result = Messages::Actions.play({})
    assert_equal(
      {
        response: 'success',
        display: I18n.t('actions.play.success'),
        javascript: 'Sound.play();'
      },
      result
    )
  end

  def test_stop
    result = Messages::Actions.stop({})
    assert_equal(
      {
        response: 'success',
        display: I18n.t('actions.stop.success'),
        javascript: 'Sound.stop();'
      },
      result
    )
  end


end


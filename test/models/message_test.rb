require './test/test_helper'

class MessageTest < ActiveSupport::TestCase

  def setup
    InMemory.rebuild
  end

  def test_parse_unknown_message
    message = Message.parse('make an awesome beat')
    assert_nil message.message_format
    assert_nil message.action
    assert_nil message.parameters
    assert_equal Message::INVALID_STATE, message.status
  end

  def test_run_unknown_message
    message = Message.parse('make an awesome beat')
    result = message.run
    assert_equal(
      I18n.t(
        'messages.errors.message_unfound',
        message: 'make an awesome beat'
      ),
      result[:display]
    )
    assert_equal('error', result[:response])
    assert_equal Message::FAILED_STATE, message.status
  end


  def test_parse_valid_message
    message_format = MessageFormat.find_by_name('show_multiple')

    message = Message.parse('show kick, snare and hihat')

    assert_equal message_format, message.message_format
    assert_equal 'show_patterns', message.action
    assert_instance_of Hash, message.parameters
    # this gets munged into a much saner form later on...
    assert_equal ["kick", ", snare", ", snare", " and hihat", "hihat"],
                 message.parameters['pattern_names']
    assert_equal Message::PENDING_STATE, message.status
  end

  def test_run_valid_message
    message = Message.parse('show kick, snare and hihat')
    Pattern.find_by_name('kick').update_attributes(:bits => 0)
    PatternStore.hash = nil
    result = message.run
    assert_instance_of Hash, result
    assert_equal %i{response display version}, result.keys
    assert result[:version]
    assert_equal 'success', result[:response]
    assert_includes(result[:display], "------1---5---9---13--17--21--25--29--")
    assert_includes(result[:display], "kick----------------------------------")
    assert_includes(result[:display], "snare---------------------------------")
    assert_includes(result[:display], "hihat---------------------------------")
  end

  def test_statuses
    message = Message.new
    message.status = Message::FAILED_STATE
    assert message.failed?
    refute message.invalid?
    refute message.pending?
    refute message.run?

    message.status = Message::INVALID_STATE
    refute message.failed?
    assert message.invalid?
    refute message.pending?
    refute message.run?

    message.status = Message::PENDING_STATE
    refute message.failed?
    refute message.invalid?
    assert message.pending?
    refute message.run?

    message.status = Message::RUN_STATE
    refute message.failed?
    refute message.invalid?
    refute message.pending?
    assert message.run?
  end

  def test_parse_show_speed
    message = Message.parse('show speed')
    assert_equal 'show_speed', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_parse_show_bpm
    message = Message.parse('show bpm')
    assert_equal 'show_speed', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_set_speed_with_bpm
    message = Message.parse('set speed to 140 bpm')
    assert_equal 'set_speed', message.action
    assert_equal({'bpm' => ['140']}, message.parameters)
  end

  def test_set_speed_without_bpm
    message = Message.parse('set speed to 140')
    assert_equal 'set_speed', message.action
    assert_equal({'bpm' => ['140']}, message.parameters)
  end

  def test_speed_up
    message = Message.parse('speed up')
    assert_equal 'speed_up', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_speed_down
    message = Message.parse('speed down')
    assert_equal 'speed_down', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_slow_down
    message = Message.parse('slow down')
    assert_equal 'speed_down', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_list_drums
    message = Message.parse('list drums')
    assert_equal 'list_drums', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_list_synths
    message = Message.parse('list synths')
    assert_equal 'list_synths', message.action
    assert_equal Hash.new, message.parameters
  end


  def test_show_all
    message = Message.parse('show all')
    assert_equal 'show_all_drums', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_show_all_drums
    message = Message.parse('show all drums')
    assert_equal 'show_all_drums', message.action
    assert_equal Hash.new, message.parameters
  end

  def test_show_one_drum
    message = Message.parse('show kick, snare and hihat')
    assert_equal 'show_patterns', message.action
    assert_equal(
      {'pattern_names' => ["kick", ", snare", ", snare", " and hihat", "hihat"]},
      message.parameters
    )
  end

  def test_play_multiple_one
    message = Message.parse('play kick on step 1')
    assert_equal 'add_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", "", nil, "", nil]
      },
      message.parameters
    )
  end

  def test_play_multiple_comma_list
    message = Message.parse('play kick on steps 1, 2, 3')
    assert_equal 'add_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", ", 2, 3", ", 3", "", nil]
      },
      message.parameters
    )
  end

  def test_play_multiple_english_list
    message = Message.parse('play kick on steps 1, 2 and 3')
    assert_equal 'add_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", ", 2", ", 2", " and 3", "3"]
      },
      message.parameters
    )
  end

  def test_play_range
    message = Message.parse('play kick on steps 1 to 5')
    assert_equal 'add_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'start_step' => '1',
        'end_step' => '5'
      },
      message.parameters
    )
  end

  def test_play_range_skipping
    message = Message.parse('play kick on steps 1 to 5 skipping 2')
    assert_equal 'add_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'start_step' => '1',
        'end_step' => '5',
        'block_size' => '2'
      },
      message.parameters
    )
  end

  def test_do_not_play_multiple_one
    message = Message.parse('do not play kick on step 1')
    assert_equal 'clear_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", "", nil, "", nil]
      },
      message.parameters
    )
  end

  def test_do_not_play_multiple_comma_list
    message = Message.parse('do not play kick on steps 1, 2, 3')
    assert_equal 'clear_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", ", 2, 3", ", 3", "", nil]
      },
      message.parameters
    )
  end

  def test_do_not_play_multiple_english_list
    message = Message.parse('do not play kick on steps 1, 2 and 3')
    assert_equal 'clear_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'steps' => ["1", ", 2", ", 2", " and 3", "3"]
      },
      message.parameters
    )
  end

  def test_do_not_play_range
    message = Message.parse('do not play kick on steps 1 to 5')
    assert_equal 'clear_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'start_step' => '1',
        'end_step' => '5'
      },
      message.parameters
    )
  end

  def test_do_not_play_range_skipping
    message = Message.parse('do not play kick on steps 1 to 5 skipping 2')
    assert_equal 'clear_steps', message.action
    assert_equal(
      {
        'pattern_name' => "kick",
        'start_step' => '1',
        'end_step' => '5',
        'block_size' => '2'
      },
      message.parameters
    )
  end


  def test_mute_one_pattern
    message = Message.parse('mute kick')
    assert_equal 'mute_unmute', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", "", nil, "", nil],
        'mode' => 'mute'
      },
      message.parameters
    )
  end

  def test_mute_list
    message = Message.parse('mute kick, snare and hihat')
    assert_equal 'mute_unmute', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", ", snare", ", snare", " and hihat", "hihat"],
        'mode' => 'mute'
      },
      message.parameters
    )
  end

  def test_unmute_one_pattern
    message = Message.parse('unmute kick')
    assert_equal 'mute_unmute', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", "", nil, "", nil],
        'mode' => 'unmute'
      },
      message.parameters
    )
  end

  def test_unmute_list
    message = Message.parse('unmute kick, snare and hihat')
    assert_equal 'mute_unmute', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", ", snare", ", snare", " and hihat", "hihat"],
        'mode' => 'unmute'
      },
      message.parameters
    )
  end

  def test_mute_all
    message = Message.parse('mute all')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'mute', 'group' => ''},
      message.parameters
    )
  end

  def test_mute_all_drums
    message = Message.parse('mute all drums')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'mute', 'group' => ' drums'},
      message.parameters
    )
  end

  def test_mute_all_synths
    message = Message.parse('mute all synths')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'mute', 'group' => ' synths'},
      message.parameters
    )
  end

  def test_unmute_all
    message = Message.parse('unmute all')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'unmute', 'group' => ''},
      message.parameters
    )
  end

  def test_unmute_all_drums
    message = Message.parse('unmute all drums')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'unmute', 'group' => ' drums'},
      message.parameters
    )
  end

  def test_unmute_all_synths
    message = Message.parse('unmute all synths')
    assert_equal 'mute_unmute_all', message.action
    assert_equal(
      {'mode' => 'unmute', 'group' => ' synths'},
      message.parameters
    )
  end

  def test_clear_one
    message = Message.parse('clear kick')
    assert_equal 'clear_patterns', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", "", nil, "", nil]
      },
      message.parameters
    )
  end

  def test_clear_list
    message = Message.parse('clear kick, snare and hihat')
    assert_equal 'clear_patterns', message.action
    assert_equal(
      {
        "pattern_names" => ["kick", ", snare", ", snare", " and hihat", "hihat"]
      },
      message.parameters
    )
  end

  def test_clear_all_drums
    message = Message.parse('clear all drums')
    assert_equal 'clear_all', message.action
    assert_equal(
      {
        'group' => [' drums']
      },
      message.parameters
    )
  end

  def test_clear_all_synths
    message = Message.parse('clear all synths')
    assert_equal 'clear_all', message.action
    assert_equal(
      {
        'group' => [' synths']
      },
      message.parameters
    )
  end

  def test_clear_all
    message = Message.parse('clear all')
    assert_equal 'clear_all', message.action
    assert_equal(
      {
        'group' => ['']
      },
      message.parameters
    )
  end

  def test_set_synth
    message = Message.parse('set synth to sine')
    assert_equal 'set_synth', message.action
    assert_equal(
      {'synth' => ['sine']},
      message.parameters
    )
  end

  def test_set_note_length
    message = Message.parse('set note length to 4')
    assert_equal 'set_note_length', message.action
    assert_equal(
      {'note_steps' => ['4']},
      message.parameters
    )
  end

  def test_add_notes_one_note
    message = Message.parse('play c4 on step 1')
    assert_equal 'add_notes', message.action
    assert_equal(
      {
        'note_names' => 'c4 ',
        'extra' => 'c4 ',
        'start_step' => '1'
      },
      message.parameters
    )
  end

  def test_add_notes_melody
    message = Message.parse('play c4, d4, f#4 on step 1')
    assert_equal 'add_notes', message.action
    assert_equal(
      {
        'note_names' => 'c4, d4, f#4 ',
        'extra' => 'f#4 ',
        'start_step' => '1'
      },
      message.parameters
    )
  end

  def test_add_notes_melody_with_gaps
    message = Message.parse('play c4, d4, f#4 on step 1 skipping 2')
    assert_equal 'add_notes', message.action
    assert_equal(
      {
        'note_names' => 'c4, d4, f#4 ',
        'extra' => 'f#4 ',
        'start_step' => '1',
        'block_size' => '2'
      },
      message.parameters
    )
  end

  def test_clear_pitches_one_pitch
    message = Message.parse('do not play c#4 on sine')
    assert_equal 'clear_pitches', message.action
    assert_equal(
      {
        'note_names' => 'c#4 ',
        'extra' => 'c#4 ',
        'synth' => 'sine'
      },
      message.parameters
    )
  end

  def test_clear_pitches_list
    message = Message.parse('do not play c#4, d4, d#4 on sine')
    assert_equal 'clear_pitches', message.action
    assert_equal(
      {
        'note_names' => 'c#4, d4, d#4 ',
        'extra' => 'd#4 ',
        'synth' => 'sine'
      },
      message.parameters
    )
  end

  def test_clear_pitches_range
    message = Message.parse('do not play c#4 to g4 on sine')
    assert_equal 'clear_pitches', message.action
    assert_equal(
      {
        'start_note' => 'c#4',
        'end_note' => 'g4',
        'synth' => 'sine'
      },
      message.parameters
    )
  end

  def test_describe_synths
    message = Message.parse('describe sine')
    assert_equal 'describe_synth', message.action
    assert_equal(
      {'synth' => ['sine']},
      message.parameters
    )
  end

  def test_list_params
    message = Message.parse('list params for sine')
    assert_equal 'list_params', message.action
    assert_equal(
      {'synth' => ['sine']},
      message.parameters
    )
  end

  def test_list_parameterss
    message = Message.parse('list parameters for sine')
    assert_equal 'list_params', message.action
    assert_equal(
      {'synth' => ['sine']},
      message.parameters
    )
  end

  def test_set_parameter_no_param
    message = Message.parse('set sine volume to 10')
    assert_equal 'set_param', message.action
    assert_equal(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '10'
      },
      message.parameters
    )
  end

  def test_set_parameter_with_param
    message = Message.parse('set sine param volume to 10')
    assert_equal 'set_param', message.action
    assert_equal(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '10'
      },
      message.parameters
    )
  end

  def test_set_parameter_with_parameter
    message = Message.parse('set sine parameter volume to 10')
    assert_equal 'set_param', message.action
    assert_equal(
      {
        'synth' => 'sine',
        'parameter' => 'volume',
        'value' => '10'
      },
      message.parameters
    )
  end

  def test_play
    message = Message.parse('play')
    assert_equal 'play', message.action
    assert_equal({}, message.parameters)
  end 

  def test_stop
    message = Message.parse('stop')
    assert_equal 'stop', message.action
    assert_equal({}, message.parameters)
  end


end

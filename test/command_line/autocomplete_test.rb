require 'test_helper'

class CommandLine::AutocompleteTest < ActiveSupport::TestCase
  include CommandLine::Autocomplete

  def test_drum_names
    assert_equal(
      drum_names,
      ["crash", "hihat", "kick", "snare", "tom1", "tom2", "tom3"]
    )
  end

  def test_synth_names
    assert_equal(
      synth_names,
      ["anne", "brian", "polly", "sarah", "trevor"]
    )
  end

  def test_notes_for_synth_anne
    assert_equal(
      notes_for_synth('anne'),
      [
        "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5",
        "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5",
        "A5", "A#5", "B5", "C6", "C#6", "D6", "D#6",
        "E6", "F6", "F#6", "G6"
      ]
    )
  end

  def test_notes_for_synth_brian
    assert_equal(
      notes_for_synth('brian'),
      [
        "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3",
        "B3", "C4", "C#4", "D4", "D#4", "E4", "F4",
        "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5",
        "C#5", "D5", "D#5", "E5"
      ]
    )
  end

  def test_speeds
    assert_equal(
      [60, 80, 100, 120, 140, 160, 180, 200],
      speeds
    )
  end

  def test_original_options
    options
    assert_kind_of(Array, @original_options)
    assert_includes(@original_options, 'show -drum-, -drum- and -drum-')
    assert_includes(@original_options, 'do not play -drum- on step 1 and 5')
    assert_includes(@original_options, 'compile to sonic pi')
  end

  def test_options
    options
    assert_includes(@options, 'set speed to 160 bpm')
    assert_includes(@options, 'show kick')
    assert_includes(@options, 'show tom3, snare and hihat')
    assert_includes(@options, 'play F# 5, C 6, D# 5, C 5 from step 1')
  end

  def test_each_replacement
    opts = each_replacement(
      'show -drum-, -drum- and -drum-',
      {
        '-drum-' => %w{kick snare hihat crash tom1 tom2 tom3},
        '-synth' => %w{brian trevor sarah anne polly}
      }
    )
    assert_includes(opts.to_a, 'show kick, snare and hihat')
    refute_includes(opts.to_a, 'show kick, kick and kick')
  end

  def test_each_replacement_multiple_values
    opts = each_replacement(
      'set -synth- -parameter- to -value-',
      {
        '-synth-' => %w{brian trevor sarah anne polly},
        '-parameter-' => %w{volume fm_depth},
        '-value-' => [10, 20, 30, 40]
      }
    )
    assert_includes(opts.to_a, 'set trevor volume to 10')
    assert_includes(opts.to_a, 'set sarah fm_depth to 40')
    refute_includes(opts.to_a, 'set sarah 20 to fm_depth')
  end

end
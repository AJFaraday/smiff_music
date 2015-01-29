require './test/test_helper'

class SynthsHelperTest < ActionView::TestCase

  def test_display_midi_note
    assert_equal(
      SynthsHelper.display_midi_note(60),
      'C 4'
    )
    assert_equal(
      SynthsHelper.display_midi_note(69),
      'A 4'
    )
    assert_equal(
      SynthsHelper.display_midi_note(72),
      'C 5'
    )
  end

  def test_display_midi_note_sharps
    assert_equal(
      SynthsHelper.display_midi_note(61),
      'C# 4'
    )
    assert_equal(
      SynthsHelper.display_midi_note(70),
      'A# 4'
    )
    assert_equal(
      SynthsHelper.display_midi_note(73),
      'C# 5'
    )
  end

  def test_translate_note_to_midi
    assert_equal(
      SynthsHelper.translate_note_to_midi('C 4'),
      60
    )
    assert_equal(
      SynthsHelper.translate_note_to_midi('A 4'),
      69
    )
    assert_equal(
      SynthsHelper.translate_note_to_midi('C 5'),
      72
    )
  end

  def test_translate_note_to_midi_sharps
    assert_equal(
      SynthsHelper.translate_note_to_midi('C# 4'),
      61
    )
    assert_equal(
      SynthsHelper.translate_note_to_midi('A#4'),
      70
    )
    assert_equal(
      SynthsHelper.translate_note_to_midi('C#5'),
      73
    )
  end

end

require './test/test_helper'

class ContextHelpTest < ActiveSupport::TestCase

  def setup
    InMemory.rebuild
  end

  def test_substitutions_are_made
    path = File.join(Rails.root, 'docs', 'context_help', 'test.md')
    content = ContextHelp.render_file(
      path,
      {
        name: 'Andrew',
        number: 99,
        unused: 'unused'
      }
    )
    assert_includes(content, 'Andrew')
    assert_includes(content, '99')
    refute_includes(content, 'unused')
  end

  def test_help_for_kick_drum
    help = ContextHelp.for('drum', 'kick')
    assert_includes(help, "'kick' is a drum, you could try these messages to change kick:")
    assert_includes(help, "* play kick on step 1")
    help = ContextHelp.for('drum', 'snare')
    assert_includes(help, "* play snare on step 1")
  end

  def test_help_for_drums
    help = ContextHelp.for('drum')
    assert_includes(
      help,
      'Drums provide the rhythm for SMIFF.'
    )
    assert_includes(help, "* list drums")
    assert_includes(help, "* play kick on step 1")
    assert_includes(help, "* mute all drums")
    assert_includes(help, "* show all drums")
  end

  def test_help_for_synths
    help = ContextHelp.for('synth')
    assert_includes(
      help,
      'Synthesisers provide the melody and harmony for SMIFF.'
    )
    assert_includes(help, "* list synths")
    assert_includes(help, "* set synth to anne")
    assert_includes(help, "* mute all synths")
    assert_includes(help, "* clear all synths")
  end

  def test_help_for_sarah_synth
    help = ContextHelp.for('synth', 'sarah')
    assert_includes(
      help,
      "'sarah' is a Simple synthesiser"
    )
    assert_includes(help, '* describe sarah')
    assert_includes(help, '* play C 5 on step 1')
    assert_includes(help, '* play C 5, C 7 from step 9')
    assert_includes(help, '* do not play C 7 on sarah')
  end

  def test_help_for_unknown_type
    assert_raise RuntimeError do
      ContextHelp.for('unknown')
    end
  end

  def test_guessed_drums
    assert_equal(
      ContextHelp.for('drum'),
      ContextHelp.guess('I want help with drums')
    )
  end

  def test_guessed_drums_from_synonym
    assert_equal(
      ContextHelp.for('drum'),
      ContextHelp.guess("help me with rhythm")
    )
  end

  def test_guessed_kick_drum
    assert_equal(
      ContextHelp.for('drum', 'kick'),
      ContextHelp.guess("help me with kick")
    )

    assert_equal(
      ContextHelp.for('drum', 'kick'),
      ContextHelp.guess("help me with kick drum")
    )

    assert_equal(
      ContextHelp.for('drum', 'kick'),
      ContextHelp.guess("help me with that drum called kick")
    )
  end

  def test_guesser_can_not_help
    response = ContextHelp.guess("help me make awesome music")
    assert_includes(response, "I'm sorry")
    assert_includes(response, "I can't help you with that")
  end

end
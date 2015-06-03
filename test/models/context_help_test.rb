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
      'Drums provide the rhythm for SMIFF. You could try these messsages to change some drums:'
    )
    assert_includes(help, "* play kick on step 1")
    assert_includes(help, "* mute all drums")
    assert_includes(help, "* show all drums")
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
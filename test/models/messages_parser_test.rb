require './test/test_helper'

# testing Messages::Parser
class MessagesParserTest < ActiveSupport::TestCase

  def setup
    MessageFormat.rebuild
  end

  def test_weight_regexes
    parser = Messages::Parser.new
    assert_instance_of Hash, parser.weight_regexes
    assert_equal [0,1,2,3], parser.weight_regexes.keys.sort
    parser.weight_regexes.each do |key, value|
      assert_instance_of Regexp, value
    end
  end

  def test_parse_invalid_message
    parser = Messages::Parser.new
    parser.parse('make sick music')
    assert_nil parser.parsed
  end

  def test_parse_valid_message
    message_format = MessageFormat.find_by_name('show_multiple')

    parser = Messages::Parser.new
    parser.parse('show kick, snare and hihat')
    assert parser.parsed
    assert_equal message_format, parser.message_format
    assert_equal(
      {"pattern_names"=>["kick", ", snare", ", snare", " and hihat", "hihat"]},
      parser.parameters
    )
  end

end
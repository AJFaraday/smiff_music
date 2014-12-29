require './test/test_helper'

class MessageFormatTest < ActiveSupport::TestCase

  def test_regex_conversion
    message_format = MessageFormat.new(
      regex: 'get (\w) from this sentence'
    )
    assert_instance_of Regexp, message_format.regex
  end

end

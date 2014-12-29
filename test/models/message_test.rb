require './test/test_helper'

class MessageTest < ActiveSupport::TestCase

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
    assert_equal('error',result[:response])
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
    result = message.run
    assert_instance_of Hash, result
    assert_equal %i{response display version}, result.keys
    assert result[:version]
    assert_equal 'success', result[:response]
    assert_equal(
      "------1---5---9---13--17--21--25--29--
kick----------------------------------
snare---------------------------------
hihat---------------------------------
",
      result[:display]
    )
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

end

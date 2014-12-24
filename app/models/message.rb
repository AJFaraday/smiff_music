class Message < ActiveRecord::Base

  belongs_to :message_format

  def Message.parse(text)
    message = Message.new(
      source_text: text
    )
    parser = Messages::Parser.new
    parser.parse(text)
    if parser.parsed
      message.message_format = parser.message_format
      message.action = "#{parser.message_format.action}(#{parser.parameters})"
      message.status = 1
    else
      message.status = 0
    end
    message.save!
    message
  end

end

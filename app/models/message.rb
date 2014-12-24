class Message < ActiveRecord::Base
 
  # Statuses: 
  FAILED_STATE  = -1 # This has been run, but was unable to take place.
  INVALID_STATE =  0 # The message was not recognised, it is now inactive.
  PENDING_STATE =  1 # This message was regocnised, but has not yet been enacted.
  RUN_STATE     =  2 # The message was run, and was able to take place. It is now ended.


  belongs_to :message_format
  serialize :parameters

  def Message.parse(text)
    message = Message.new(
      source_text: text
    )
    parser = Messages::Parser.new
    parser.parse(text)
    if parser.parsed
      message.message_format = parser.message_format
      message.action = parser.message_format.action
      message.parameters = parser.parameters
      message.status = 1
    else
      message.status = 0
    end
    message.save!
    message.run
    message
  end

  def run
    if self.pending?
      result = Messages::Actions.run(action,parameters)
      case result[:response]
        when 'success'
          self.status = 2
        else # failure, error
          self.status = -1
      end
      save!
      return result[:display]
    end 
  end 

  def failed?
    status == FAILED_STATE
  end 

  def invalid?
    status == INVALID_STATE 
  end

  def pending?
    status == PENDING_STATE 
  end

  def run?
    status == RUN_STATE
  end 


end

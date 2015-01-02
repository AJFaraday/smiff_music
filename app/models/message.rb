class Message < ActiveRecord::Base

  # Statuses: 
  FAILED_STATE = -1 # This has been run, but was unable to take place.
  INVALID_STATE = 0 # The message was not recognised, it is now inactive.
  PENDING_STATE = 1 # This message was regocnised, but has not yet been enacted.
  RUN_STATE = 2 # The message was run, and was able to take place. It is now ended.

  cattr_accessor :failure_log

  belongs_to :message_format
  serialize :parameters

  def Message.parse(text)
    message = Message.new(
      source_text: text
    )
    parser = Messages::Parser.new
    parser.parse(text.downcase)
    if parser.parsed
      message.message_format = parser.message_format
      message.action = parser.message_format.action
      message.parameters = parser.parameters
      message.status = Message::PENDING_STATE
    else
      message.status = Message::INVALID_STATE
    end
    message.save!
    message
  end

  def run
    if self.pending?
      result = Messages::Actions.run(action, parameters)
      case result[:response]
        when 'success'
          self.status = Message::RUN_STATE
        else # failure, error
          self.status = Message::FAILED_STATE
          log_failure(result)
      end
      result[:version] = PatternStore.version
      save!
      return result
    elsif self.invalid?
      log_failure
      self.status = Message::FAILED_STATE
      save!
      return {
        display: I18n.t(
        'messages.errors.message_unfound',
        :message => self.source_text
      ),
        response: 'error'
      }
    end
  end

  def Message.failure_log
    return @@failure_log if @@failure_log
    logfile = File.open(File.join(Rails.root, 'log', 'failed_messages.log'), 'a')
    logfile.sync = true
    @@failure_log = Logger.new(logfile)
    @@failure_log
  end

  def log_failure(result=nil)
    puts 'logging failure'
    if result
      Message.failure_log.info("[#{result[:response]}] #{self.source_text}")
    else
      Message.failure_log.info("[failure] #{self.source_text}")
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

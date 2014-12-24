class Messages::Actions

  AVAILABLE_ACTIONS = ['show_patterns']

  extend Messages::Actions::Show

  def self.run(action, arguments)
    if Messages::Actions::AVAILABLE_ACTIONS.include?(action)
      self.send(action,arguments)
    else
      return {
        response: 'failure',
        display: I18n.t(
          'messages.errors.not_implemented',
          action: action
        )
      }
    end
  end 

end 

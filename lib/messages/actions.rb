class Messages::Actions

  AVAILABLE_ACTIONS = ['show_patterns']

  extend Messages::Actions::Show

  def self.run(action, arguments)
    if Messages::Actions::AVAILABLE_ACTIONS.include?(action)
      self.send(action, arguments)
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

  def self.munge_list(list)
    list.compact!
    list.reject! { |x| x.blank? }
    list = list.collect do |x|
      x.split(',').collect { |x| x.strip }.reject { |x| x.blank? }
    end
    list = list.flatten.uniq
    puts list.inspect
    list
  end

end


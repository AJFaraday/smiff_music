class Messages::Actions

  require 'active_support'

  AVAILABLE_ACTIONS = %w{
    show_patterns add_steps clear_patterns clear_steps
    set_speed
  }

  extend Messages::Actions::Show
  extend Messages::Actions::AddSteps
  extend Messages::Actions::ClearPatterns
  extend Messages::Actions::ClearSteps
  extend Messages::Actions::SetSpeed

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

  def self.pattern_not_found(pattern_names)
    {
      response: 'failure',
      display: I18n.t(
        'actions.show_patterns.errors.no_pattern',
        names: pattern_names.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
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


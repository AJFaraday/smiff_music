class Messages::Actions

  require 'active_support'

  AVAILABLE_ACTIONS = %w{
    show_patterns add_steps clear_patterns clear_steps
    set_speed show_speed speed_up speed_down list_drums
    clear_all_drums mute_unmute
  }

  extend Messages::Actions::Show
  extend Messages::Actions::AddSteps
  extend Messages::Actions::ClearPatterns
  extend Messages::Actions::ClearSteps
  extend Messages::Actions::SetSpeed
  extend Messages::Actions::ShowSpeed
  extend Messages::Actions::SpeedUp
  extend Messages::Actions::SpeedDown
  extend Messages::Actions::ListDrums
  extend Messages::Actions::ClearAllDrums
  extend Messages::Actions::MuteUnmute

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
    puts "munging #{list.inspect}"
    if list.is_a?(Array)
      list.compact!
      list.reject! { |x| x.blank? }
      list = list.collect do |x|
        x.split(',').collect { |x| x.strip }.reject { |x| x.blank? }
      end
      list.flatten!
      list = list.collect do |x|
        x.split('and').collect { |x| x.strip }.reject { |x| x.blank? }
      end
      list.flatten!
      list.uniq!
      list
    else
      [list ]
    end
  end

end


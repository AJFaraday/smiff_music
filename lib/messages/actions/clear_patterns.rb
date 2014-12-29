module Messages::Actions::ClearPatterns

  attr_accessor :pattern_names
  attr_accessor :patterns

  def clear_patterns(args)
    self.pattern_names = munge_list(args['pattern_names'])
    self.patterns = Pattern.where(name: self.pattern_names)
    return pattern_not_found([self.pattern_names]) unless self.patterns.any?
    puts patterns.inspect
    self.patterns.each{|x| x.update_attribute(:pattern_indexes, [])}
    return {
      response: 'success',
      display: I18n.t(
        "actions.clear.success.#{self.patterns.count > 1 ? 'other' : 'one'}",
        names: self.pattern_names.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
  end

end
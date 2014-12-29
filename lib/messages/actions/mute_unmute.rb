module Messages::Actions::MuteUnmute

  attr_accessor :pattern_names
  attr_accessor :patterns

  def mute_unmute(args)
    self.pattern_names = munge_list(args['pattern_names'])
    self.patterns = Pattern.where(:name => self.pattern_names)

    self.patterns.each do |pattern|
      pattern.update_attribute(
        :muted,
        args['mode'] == 'mute'
      )
    end

    return {
      response: 'success',
      display: I18n.t(
        "actions.mute_unmute.success.#{self.patterns.count > 1 ? 'other' : 'one'}",
        names: self.pattern_names.to_sentence(
          last_word_connector: ' and '
        ),
        action: I18n.t("actions.mute_unmute.#{args['mode']}")
      )
    }
  end

end

module Messages::Actions::MuteUnmuteAll

  def mute_unmute_all(args)
    mode = args['mode'][0]
    Pattern.all.each do |pattern|
      pattern.update_attribute(
        :muted,
        mode == 'mute'
      )
    end
    return {
      response: 'success',
      display: I18n.t(
        "actions.mute_unmute_all.success",
        action: I18n.t("actions.mute_unmute_all.#{mode}")
      )
    }
  end 
 
end

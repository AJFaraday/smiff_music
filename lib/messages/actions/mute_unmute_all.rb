module Messages::Actions::MuteUnmuteAll

  def mute_unmute_all(args)
    mode = args['mode'][0]
    Pattern.update_all(muted: mode == 'mute')
    PatternStore.hash['patterns'].each{|k,value| value[:muted] = mode == 'mute' if value.is_a?(Hash)}
    PatternStore.version += 1
    return {
      response: 'success',
      display: I18n.t(
        "actions.mute_unmute_all.success",
        action: I18n.t("actions.mute_unmute_all.#{mode}")
      )
    }
  end 
 
end

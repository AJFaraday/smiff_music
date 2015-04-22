module Messages::Actions::MuteUnmuteAll

  def mute_unmute_all(args)
    mode = args['mode']
    group = args['group']
    if ['', ' drums'].include?(group)
      Pattern.update_all(muted: mode == 'mute')
      PatternStore.hash['patterns'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
      PatternStore.increment_version(Pattern)
    end
    if ['', ' synths'].include?(group)
      Synth.update_all(muted: mode == 'mute')
      PatternStore.hash['synths'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
      PatternStore.increment_version(Synth)
    end
    return {
      response: 'success',
      display: I18n.t(
        "actions.mute_unmute_all.success",
        action: I18n.t("actions.mute_unmute_all.#{mode}"),
        group: group.singularize
      )
    }
  end

end

module Messages::Actions::MuteUnmuteAll

  def mute_unmute_all(args)
    mode = args['mode']
    group = args['group']
    if ['', ' drums'].include?(group)
      puts 'muting drums'
      Pattern.update_all(muted: mode == 'mute')
      PatternStore.hash['patterns'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
    end
    if ['', ' synths'].include?(group)
      puts 'muting synths'
      Synth.update_all(muted: mode == 'mute')
      PatternStore.hash['synths'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
    end

    PatternStore.version += 1
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

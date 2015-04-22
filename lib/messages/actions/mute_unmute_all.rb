module Messages::Actions::MuteUnmuteAll

  def mute_unmute_all(args)
    mode = args['mode']
    group = args['group']
    if ['', ' drums'].include?(group)
      Pattern.update_all(muted: mode == 'mute')
      PatternStore.hash['patterns'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
      Pattern.where(:purpose => 'event').each{|x| PatternStore.increment_version(x)}
    end
    if ['', ' synths'].include?(group)
      Synth.update_all(muted: mode == 'mute')
      PatternStore.hash['synths'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
      Synth.all.each{|x| PatternStore.increment_version(x)}
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

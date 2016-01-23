module Messages
  module Actions
    module MuteUnmuteAll

      def mute_unmute_all(args)
        mode = args['mode']
        group = args['group']
        if ['', ' drums'].include?(group)
          Pattern.all.each { |pattern| pattern.muted = (mode == 'mute'); pattern.save }
          PatternStore.hash['patterns'].each { |k, value| value[:muted] = mode == 'mute' if value.is_a?(Hash) }
          PatternStore.increment_version(Pattern)
        end
        if ['', ' synths'].include?(group)
          Synth.all.each { |synth| synth.muted = (mode == 'mute'); synth.save }
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
  end
end

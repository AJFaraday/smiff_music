module Messages::Actions::ClearAll

  # note: this may be 'antisocial' when there is more than one user
  def clear_all(args)
    case args['group'][0]
      when ' synths'
        Pattern.where(purpose: 'note_on').each { |pattern| pattern.bits = 0; pattern.save }
        Synth.all.each { |synth| synth.pitches = nil ; synth.save }
        PatternStore.hash['synths'].each do |k, value|
          value[:note_off_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        PatternStore.increment_version(Synth)
      when ' drums'
        Pattern.where(purpose: 'event').each { |pattern| pattern.bits = 0; pattern.save }
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        PatternStore.increment_version(Pattern)
      else
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }

        Pattern.where(purpose: ['note_on', 'event']).each { |pattern| pattern.bits = 0; pattern.save }
        Synth.all.each { |synth| synth.pitches = nil ; synth.save }
        PatternStore.hash['synths'].each do |k, value|
          value[:note_on_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        PatternStore.increment_version(Synth)
        PatternStore.increment_version(Pattern)
    end

    PatternStore.version += 1

    return {
      response: 'success',
      display: I18n.t(
        'actions.clear_all_drums.success',
        group: args['group'][0].singularize
      )
    }
  end

end

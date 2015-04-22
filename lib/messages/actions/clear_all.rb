module Messages::Actions::ClearAll

  # note: this may be 'antisocial' when there is more than one user
  def clear_all(args)
    case args['group'][0]
      when ' synths'
        Pattern.where(purpose: 'note_on').update_all(bits: 0)
        Synth.update_all(pitches: nil)
        PatternStore.hash['synths'].each do |k, value| #
          value[:note_off_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        PatternStore.increment_version(Synth)
      when ' drums'
        Pattern.where(purpose: 'event').update_all(bits: 0)
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        PatternStore.increment_version(Pattern)
      else
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        Pattern.all.each{|x| PatternStore.increment_version(x)}

        Pattern.where(purpose: ['note_on', 'event']).update_all(bits: 0)
        Synth.update_all(pitches: nil)
        PatternStore.hash['synths'].each do |k, value| #
          value[:note_off_steps] = 0
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

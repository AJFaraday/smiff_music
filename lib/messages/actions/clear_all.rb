module Messages::Actions::ClearAll

  # note: this may be 'antisocial' when there is more than one user
  def clear_all(args)
    case args['group'][0]
      when ''
        Pattern.update_all(bits: 0)
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        PatternStore.hash['synths'].each do |k, value|
          value[:note_on_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        Pattern.all.each{|x| PatternStore.increment_version(x)}
      when ' synths'
        Pattern.where(purpose: ['note_on', 'note_off']).update_all(bits: 0)
        Synth.update_all(pitches: nil)
        PatternStore.hash['synths'].each do |k, value| #
          value[:note_off_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        Synth.all.each{|x| PatternStore.increment_version(x)}
      when ' drums'
        Pattern.where(purpose: 'event').update_all(bits: 0)
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        Pattern.where(:purpose => 'event').each{|x| PatternStore.increment_version(x)}
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

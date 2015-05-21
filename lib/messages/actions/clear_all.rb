module Messages::Actions::ClearAll

  # note: this may be 'antisocial' when there is more than one user
  def clear_all(args)
    case args['group'][0]
      when ' synths'
        Pattern.all.select{|p|p.purpose == 'event'}.each{|p|p.bits = 0}
        Synth.all.each{|s|s.pitches = nil}  
        PatternStore.hash['synths'].each do |k, value| #
          value[:note_off_steps] = 0
          value[:pitches] = Synth.first.pitches
        end
        PatternStore.increment_version(Synth)
      when ' drums'
        Pattern.all.select{|p|p.purpose == 'event'}.each{|p|p.bits = 0}
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }
        PatternStore.increment_version(Pattern)
      else
        PatternStore.hash['patterns'].each { |k, value| value[:steps] = 0 }

        Pattern.all.select{|p|['note_on', 'event'].include?(p.purpose)}.each{|p|p.bits = 0}
        Synth.all.each{|s|s.pitches = nil}
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

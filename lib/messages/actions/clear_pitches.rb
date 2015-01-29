module Messages::Actions::ClearPitches

  def clear_pitches(args)
    synth = Synth.find_by_name(args['synth'])
    return pattern_not_found([args['synth']]) unless synth
    if args.keys.include?('note_names')
      note_names = parse_note_names(args['note_names'])
      midi_notes = note_names.collect{|note| translate_note_to_midi(note)}
      midi_notes.each{|pitch| synth.clear_pitch(pitch)}
      {
        response: 'successs',
        display: I18n.t(
          'actions.clear_pitches.list_cleared',
          synth: synth.name,
          note_names: note_names.to_sentence(
            last_word_connector: ' or '
          )
        )
      }
    elsif args.keys.include?('start_note') and args.keys.include?('end_note')
      start_note = parse_note_names(args['start_note'])[0]
      end_note = parse_note_names(args['end_note'])[0]
      edges = [start_note,end_note].sort
      (edges[0]..edges[1]).to_a.each{|pitch| synth.clear_pitch(pitch)}
      {
        response: 'successs',
        display: I18n.t(
          'actions.clear_pitches.range_cleared',
          synth: synth.name,
          start: args['start_note'],
          end: args['end_note']
        )
      }
    end
  end



end
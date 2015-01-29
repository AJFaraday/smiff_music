module Messages::Actions::AddNotes

  include SynthsHelper

  def add_notes(args)
    synth = Synth.find_by_name(args['synth'])
    notes = parse_note_names(args['note_names'])
    notes = notes.collect{|note| translate_note_to_midi(note)}

    if notes.count == 1
      return add_single_note(notes, synth, args)
    else
      return add_multiple_notes(notes, synth, args)
    end
  end

  def add_multiple_notes(notes, synth, args)
    step = (args['start_step'].to_i - 1)
    note_steps = args['note_steps'].to_i
    notes.each do |note|
      errors = errors_for_synth_and_note(synth, note)
      return errors if errors
    end
    notes.each do |note|
      synth.add_note(note, step, note_steps)
      step += note_steps
    end
    {
      response: 'success',
      display: I18n.t(
        'actions.add_notes.melody_added',
        start_step: args['start_step'],
        synth: synth.name
      )
    }
  end

  def add_single_note(notes, synth, args)
    note = notes[0]
    errors = errors_for_synth_and_note(synth, note)
    return errors if errors

    synth.add_note(note, (args['start_step'].to_i - 1), args['note_steps'].to_i)
    {
      response: 'success',
      display: I18n.t(
        'actions.add_notes.note_added',
        note: display_midi_note(note),
        step: args['start_step'],
        synth: synth.name
      )
    }
  end

  def errors_for_synth_and_note(synth, note)
    if note > synth.max_note
      {
        response: 'failure',
        display: I18n.t(
          'actions.add_notes.note_too_high',
          synth: synth.name,
          max: display_midi_note(synth.max_note)
        )
      }
    elsif note < synth.min_note
      {
        response: 'failure',
        display: I18n.t(
          'actions.add_notes.note_too_low',
          synth: synth.name,
          min: display_midi_note(synth.min_note)
        )
      }
    else
      nil
    end
  end

end
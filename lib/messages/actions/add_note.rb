module Messages::Actions::AddNote

  include SynthsHelper

  def add_note(args)
    notes = munge_note_names(args['note_names'])
    synth = Synth.find_by_name(args['synth'])
    note = translate_note_to_midi(args['note_name'].upcase, args['octave'])
    errors = errors_for_synth_and_note(synth, note)
    return errors if errors

    synth.add_note(note,(args['start_step'].to_i - 1), args['note_steps'].to_i)
    {
      response: 'success',
      display: I18n.t(
        'actions.add_note.note_added',
        note: display_midi_note(note),
        step: args['start_step'],
        synth: synth.name
      )
    }
  end

  def munge_note_names(note_names)
    # get rid of spaces inside note names
    tidied_note_names = note_names.split(/([a-z])[ ]+([0-9])/).join

  end

  def errors_for_synth_and_note(synth, note)
    if note > synth.max_note
      {
        response: 'failure',
        display: I18n.t(
          'actions.add_note.note_too_high',
          synth: synth.name,
          max: display_midi_note(synth.max_note)
        )
      }
    elsif note < synth.min_note
      {
        response: 'failure',
        display: I18n.t(
          'actions.add_note.note_too_low',
          synth: synth.name,
          min: display_midi_note(synth.min_note)
        )
      }
    else
      nil
    end
  end

end
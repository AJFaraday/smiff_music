module SynthsHelper

  NOTE_NAMES = %w(A A# B C C# D D# E F F# G G#)


  def step_class(synth, step,note)
    kls = (step % 4 == 0) ? 'step marker ' : 'step '
    if synth.pitch_at_step(step) == note
      if synth.patterns.note_on.pattern_indexes.include?(step)
        kls << 'note_start'
      elsif synth.active_at_step(step)
        kls << 'note_continues'
      elsif synth.patterns.note_off.pattern_indexes.include?(step) and synth.active_at_step(step - 1)
        kls << 'note_end'
      else
        kls << 'inactive'
      end
    else
      kls << 'inactive'
    end
    kls
  end

  def display_midi_note(midi)
    note_name = NOTE_NAMES[(midi - 21) % 12]
    octave = (midi - 12) / 12
    "#{note_name} #{octave}"
  end

  module_function(:display_midi_note)

end


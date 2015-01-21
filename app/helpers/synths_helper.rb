module SynthsHelper

  NOTE_NAMES = %w(A A# B C C# D D# E F F# G G#)



  def display_midi_note(midi)
    note_name = NOTE_NAMES[(midi - 21) % 12]
    octave = (midi - 12) / 12
    "#{note_name} #{octave}"
  end

  module_function(:display_midi_note)

end


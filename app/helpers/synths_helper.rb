module SynthsHelper

  BASE_NOTE_NAMES = %w{C D E F G A B}

  BASE_NOTE_NAME_INDEXES = {
    'C' => 0, 'D' => 2, 'E' => 4, 'F' => 5,
    'G' => 7, 'A' => 9, 'B' => 11
  }

  VALID_NOTE_NAMES = %w(
    C  D  E  F  G  A  B
    C# D# E# F# G# A# B#
    CB DB EB FB GB AB BB
  )

  DISPLAY_NOTE_NAMES = %W{C C# D D# E F F# G G# A A# B}

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

  def display_parameter(synth, param)
    class_name = "synth_#{synth.id}_#{param}"
    output = content_tag(:dt, Synth.human_attribute_name(param))
    if [:max_note, :min_note].include?(param)
      output << content_tag(:dd, display_midi_note(synth.send(param)), :class => class_name)
    else
      output << content_tag(:dd, synth.send(param), :class => class_name)
    end
    output
  end

  def display_midi_note(midi)
    note_name = DISPLAY_NOTE_NAMES[(midi - 24) % 12]
    octave = (midi - 12) / 12
    "#{note_name} #{octave}"
  end

  def translate_note_to_midi(note_name)
    match_data = note_name.match /([a-zA-Z][#b]?)(?: )?([0-9])/
    note = match_data[1].upcase
    octave = match_data[2].to_i
    return "#{note} is not a note" unless VALID_NOTE_NAMES.include?(note)
    octave_semitone = BASE_NOTE_NAME_INDEXES[note[0].upcase]
    octave_semitone += 1 if note[1] == '#'
    octave_semitone -= 1 if note[1] == 'B'
    ((octave.to_i + 1) * 12) + octave_semitone
  end

  module_function(:display_midi_note)
  module_function(:translate_note_to_midi)

end


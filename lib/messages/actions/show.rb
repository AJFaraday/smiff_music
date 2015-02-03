module Messages::Actions::Show

  attr_accessor :pattern_names
  attr_accessor :patterns
  attr_accessor :synth

  def show_patterns(args)
    self.pattern_names = munge_list(args['pattern_names'])

    begin
      self.patterns = Pattern.where(:name => self.pattern_names)
      self.synth = Synth.find_by_name(self.pattern_names[0])
      if self.patterns.any?
        return {
          response: 'success',
          display: self.pattern_diagram
        }
      elsif self.synth
        return {
          response: 'success',
          display: self.melody_diagram
        }
      else
        return {
          response: 'failure',
          display: I18n.t(
            'actions.show_patterns.errors.no_patterns',
            names: pattern_names.to_sentence(
              last_word_connector: ' and '
            )
          )
        }
      end
    rescue => er
      Rails.logger.info er.message
      Rails.logger.info er.backtrace.join("\n")
      return {
        response: 'error',
        display: I18n.t(
          'actions.show_patterns.errors.unknown_error',
          names: self.pattern_names.join(','),
          message: er.message
        )
      }
    end
  end

  def melody_diagram
    length = synth.step_count
    timeline = (1..length).to_a.in_groups_of(4).collect { |group| group[0].to_s.ljust(4, '-') }
    timeline = timeline.join()
    label_length = 5

    result = "#{'-' * label_length}#{timeline}\n"
    (synth.min_note..synth.max_note).to_a.reverse.each do |pitch|
      result << pitch_diagram(pitch)
    end
    result
  end

  def pitch_diagram(pitch)
    result = display_midi_note(pitch).ljust(5, '-')
    active = false
    (0..(synth.step_count - 1)).to_a.each do |step|
      if synth.pitch_at_step(step) == pitch
        if synth.note_on.pattern_indexes.include?(step)
          result << '#'
          active = true unless synth.note_off.pattern_indexes.include?(step)
        elsif synth.note_off.pattern_indexes.include?(step)
          result << '#'
          active = false
        elsif active
          result << '#'
        else
          result << '-'
        end
      else
        result << '-'
      end
    end
    result << "\n"
    result
  end

  def pattern_diagram
    result = ""
    # work out pattern length
    length = patterns.collect { |x| x.step_count }.max
    timeline = (1..length).to_a.in_groups_of(4).collect { |group| group[0].to_s.ljust(4, '-') }
    timeline = timeline.join()
    # work out length for labels (longest + 1
    label_length = self.patterns.collect { |x| x.name.length }.max + 1
    # add timeline with gap for labels
    result << "#{'-' * label_length}#{timeline}\n"
    # add timeline for each pattern
    patterns.each do |pattern|
      pattern_diagram = ""
      until pattern_diagram.length >= length
        pattern_diagram << pattern.pattern_bits.collect { |x| x ? '#' : '-' }.join()
      end
      pattern_diagram = pattern_diagram[0..length]
      mute_state = pattern.muted ? ' (muted)' : ''
      result << "#{pattern.name.ljust(label_length, '-')}#{pattern_diagram} #{mute_state}\n"
    end
    result
  end

end 

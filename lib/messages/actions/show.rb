module Messages::Actions::Show

  attr_accessor :pattern_names
  attr_accessor :patterns

  def show_patterns(args)
    self.pattern_names = munge_list(args['pattern_names'])

    begin
      self.patterns = Pattern.where(:name => self.pattern_names)
      if self.patterns.any? 
        return {
          response: 'success',   
          display: self.pattern_diagram
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

  def pattern_diagram
    result = ""
    # work out pattern length
    length = patterns.collect{|x|x.step_count}.max
    timeline = (1..length).to_a.in_groups_of(4).collect{|group|group[0].to_s.ljust(4, '-')}      
    timeline = timeline.join()
    # work out length for labels (longest + 1
    label_length = self.patterns.collect{|x|x.name.length}.max + 1
    # add timeline with gap for labels
    result << "#{'-' * label_length}#{timeline}\n"
    # add timeline for each pattern
    patterns.each do |pattern|
      pattern_diagram = ""
      until pattern_diagram.length >= length
        pattern_diagram << pattern.pattern_bits.collect{|x|x ? '#' : '-'}.join()
      end 
      pattern_diagram = pattern_diagram[0..length]
      result << "#{pattern.name.ljust(label_length, '-')}#{pattern_diagram}\n"
    end 
    result
  end

end 

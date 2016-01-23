module Messages
  module Actions

    AVAILABLE_ACTIONS = %w{
      show_patterns add_steps clear_patterns clear_steps
      set_speed show_speed speed_up speed_down list_drums
      clear_all mute_unmute mute_unmute_all show_all_drums
      set_synth set_note_length
      add_notes clear_pitches
      list_synths describe_synth list_params set_param
      play stop help
    }

    extend Messages::Actions::Show
    extend Messages::Actions::AddSteps
    extend Messages::Actions::ClearPatterns
    extend Messages::Actions::ClearSteps
    extend Messages::Actions::SetSpeed
    extend Messages::Actions::ShowSpeed
    extend Messages::Actions::SpeedUp
    extend Messages::Actions::SpeedDown
    extend Messages::Actions::ListDrums
    extend Messages::Actions::ListSynths
    extend Messages::Actions::ClearAll
    extend Messages::Actions::MuteUnmute
    extend Messages::Actions::MuteUnmuteAll
    extend Messages::Actions::ShowAllDrums
    extend Messages::Actions::SetSynth
    extend Messages::Actions::SetNoteLength
    extend Messages::Actions::AddNotes
    extend Messages::Actions::ClearPitches
    extend Messages::Actions::DescribeSynth
    extend Messages::Actions::ListParams
    extend Messages::Actions::SetParam
    extend Messages::Actions::Play
    extend Messages::Actions::Stop
    extend Messages::Actions::Help

    def self.run(action, arguments)
      if Messages::Actions::AVAILABLE_ACTIONS.include?(action)
        self.send(action, arguments)
      else
        return {
          response: 'failure',
          display: I18n.t(
            'messages.errors.not_implemented',
            action: action
          )
        }
      end
    rescue => er
      puts er.message
      puts er.backtrace.join("\n")
      return {
        response: 'error',
        display: I18n.t('messages.errors.could_not_run')
      }
    end

    def self.pattern_not_found(pattern_names)
      pattern_names = [pattern_names] unless pattern_names.is_a?(Array)
      {
        response: 'failure',
        display: I18n.t(
          'messages.errors.pattern_not_found',
          names: pattern_names.to_sentence(
            last_word_connector: ' and '
          )
        )
      }
    end

    def self.synth_not_found(synth_name)
      return {
        response: 'failure',
        display: I18n.t(
          'messages.errors.synth_not_found',
          synth: synth_name
        )
      }
    end

    def self.munge_list(list)
      if list.is_a?(Array)
        list.compact!
        list.reject! { |x| x.blank? }
        list = list.collect do |x|
          x.split(',').collect { |x| x.strip }.reject { |x| x.blank? }
        end
        list.flatten!
        list = list.collect do |x|
          x.split('and').collect { |x| x.strip }.reject { |x| x.blank? }
        end
        list.flatten!
        list.uniq!
        list
      else
        [list]
      end
    end

    def self.parse_note_names(note_names)
      # get rid of spaces inside note names
      tidied_note_names = note_names.split(/([a-z])[ ]+([0-9])/).collect { |x| x.gsub(' ', '') }.join
      tidied_note_names.split(/[, ]+/)
    end

    def self.parsed_note_display(note_name)
      "#{note_name[0].upcase}#{note_name[1] if ['#', 'b'].include?(note_name[1])} #{note_name[-1]}"
    end

  end
end
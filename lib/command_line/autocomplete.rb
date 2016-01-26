module CommandLine
  module Autocomplete

    def options
      return @options if @options
      @original_options = File.read(
        File.join(File.dirname(__FILE__), 'commands.txt')
      ).split("\n")
      substitute_options
    end

    def substitute_options
      sub_keys = {
        '-speed' => speeds,
        '-drum-' => drum_names,
        '-synth' => synth_names,
        '-note-' => notes_for_synth('anne'), #TODO
        '-parameter-' => parameters_for_synth('anne')
      }
      @options = []
      @original_options.each do |source|
        if source.match(/-[a-z]+-/)
          sub_keys.each do |key, options|
            
          end
        else
          @options << source
        end
      end
    end


    def drum_names
      @drum_names ||= Pattern.all.collect { |x| x.name }.sort
    end

    def synth_names
      @synth_names ||= Synth.all.collect { |x| x.name }.sort
    end

    def notes_for_synth(name)
      synth_notes_lookup[name]
    end

    def parameters_for_synth(name)
      Synth.find_by_name(name).parameters.keys
    end

    def synth_notes_lookup
      return @synth_notes_lookup if @synth_notes_lookup
      @synth_notes_lookup = {}
      Synth.all.each do |synth|
        @synth_notes_lookup[synth.name] = synth.note_names
      end
      @synth_notes_lookup
    end

    def speeds
      (3..10).to_a.collect { |x| x * 20 }
    end

    def note_lengths
      [1, 2, 3, 4, 8, 16]
    end

  end
end
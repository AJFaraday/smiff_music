module CommandLine
  module Autocomplete

    include SynthsHelper

    def options
      return @options if @options
      @original_options = File.read(
        File.join(File.dirname(__FILE__), 'commands.txt')
      ).split("\n")
      substitute_options
      @options
    end

    def substitute_options
      start_time = Time.now
      sub_keys = {
        '-speed-' => speeds,
        '-drum-' => drum_names,
        '-synth-' => synth_names,
        '-note-' => note_names,
        '-melody-' => melodies,
        '-parameter-' => ['volume'],
        '-length-' => [1, 2, 3, 4, 8],
        '-value-' => [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
      }
      @options = []
      @original_options.each do |source|
        if source.match(/-[a-z]+-/)
          each_replacement(source, sub_keys).each do |result|
            @options << result
          end
        else
          @options << source
        end
      end
      #puts "#{options.count} options took #{Time.now - start_time} seconds"
    end

    def each_replacement(pattern, repl_keys)
      return enum_for(__method__, pattern, repl_keys) unless block_given?

      repl_keys = repl_keys.reject { |k, v| !pattern.include?(k) }

      keys = repl_keys.keys
      key_counts = Hash[keys.map { |key| [key, pattern.scan(key).count] }]
      keys = keys.collect { |k| Array.new(key_counts[k], k) }.flatten

      key_permutations = repl_keys.lazy.map { |key, repl|
        combinations = repl.combination(key_counts[key])
        combinations.flat_map { |comb|
          comb.permutation.to_a
        }
      }.inject(&:product)
      key_permutations.each do |perm|
        text = pattern
        keys.zip(perm.flatten).each do |key, repl|
          text = text.sub(key, '%s') % repl
        end
        yield text
      end
    end

    def drum_names
      @drum_names ||= Pattern.all.select { |x| x.purpose== 'event' }.collect { |x| x.name }.sort
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

    def note_names
      [72, 74, 76, 79, 81, 82, 84].collect { |n| display_midi_note(n) }
    end

    def melodies
      melodies = each_replacement(
        '-note-, -note-, -note-, -note-',
        {
          '-note-' => note_names
        }
      ).to_a
      melodies.shuffle[0..10]
    end

  end
end
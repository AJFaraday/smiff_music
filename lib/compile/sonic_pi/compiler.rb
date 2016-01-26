module Compile
  module SonicPi

    class Compiler

      # source is the hash from PatternStore.hash
      def initialize(source)
        @bpm = source['bpm']
        @version = source['version']
        init_drum_patterns(source)
        init_synths(source)
      end

      def init_drum_patterns(source)
        @drum_patterns = []
        source['patterns'].each do |drum, attrs|
          @drum_patterns << Compile::SonicPi::DrumPattern.new(attrs)
        end
      end

      def init_synths(source)
        @synths = []
        source['synths'].each do |name, attrs|
          @synths << Compile::SonicPi::Synth.new(name, attrs)
        end
      end

      def file_name
        return @file_name if @file_name
        time = Time.now
        @file_name = "SMIFF_#{time.year}-#{time.day}_#{time.hour}-#{time.min}-#{time.sec}.rb"
      end

      def write_file
        file_path = File.join(
          Pathname(__FILE__).dirname.parent.parent.parent,
          'public', 'files', file_name
        )
        File.open(file_path, 'w') do |file|
          file.write(self.code)
        end
        file_path
      end

      def code
        result = ""
        result << "# pattern version #{@version}\n"
        result << "use_bpm #{@bpm}\n\n"
        result << step_loop
        result
      end

      def step_loop
        result = ""
        result << "live_loop :smiff do\n"
        step_time = 0.25
        (0..31).to_a.each do |step|
          commands = []
          commands << drum_commands_for_step(step)
          commands << synth_commands_for_step(step)
          if commands.compact.any?
            result << "  sleep #{step_time}\n" unless step == 0
            result << commands.join
            step_time = 0.25
          else
            step_time += 0.25
          end
        end
        result << "  sleep #{step_time}\n"
        result << "end"
        result
      end

      def synth_commands_for_step(step)
        result = ''
        @synths.each do |synth|
          if synth.start_note_at_step?(step)
            result << synth.commands(step)
          end
        end
        if result.blank?
          nil
        else
          result
        end
      end

      def drum_commands_for_step(step)
        result = ''
        @drum_patterns.each do |drum_pattern|
          if drum_pattern.play_at_step?(step)
            result << drum_pattern.command
          end
        end
        if result.blank?
          nil
        else
          result
        end
      end

    end
  end
end
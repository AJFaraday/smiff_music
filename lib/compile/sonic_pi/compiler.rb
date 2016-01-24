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
          File.dirname(__FILE__),
          '..', '..', '..',
          'public', 'files', file_name
        )
        File.open(file_path, 'w') do |file|
          file.write(self.code)
        end
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
        (0..31).to_a.each do |step|
          @drum_patterns.each do |drum_pattern|
            if drum_pattern.play_at_step?(step)
              result << drum_pattern.command
            end
          end
          # TOOD synth plays
          result << "  sleep 0.25\n"
        end
        result << "end"
        result
      end

    end
  end
end
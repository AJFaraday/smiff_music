module Compile
  module SonicPi

    class Compiler

      # source is the hash from PatternStore.hash
      def initialize(source)
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

    end

  end
end
module Compile
  module SonicPi
    class DrumPattern

      SAMPLE_COMMAND_MAP = {
        'kick' => 'sample :drum_bass_soft',
        'snare' => 'sample :drum_snare_soft',
        'hihat' => 'sample :drum_cymbal_closed',
        'crash' => 'sample :drum_splash_soft, amp: 0.5',
        'tom1' => 'sample :drum_tom_low_soft',
        'tom2' => 'sample :drum_tom_mid_soft',
        'tom3' => 'sample :drum_tom_hi_soft'
      }

      attr_accessor :command

      # source is the hash from Pattern#to_hash
      def initialize(attrs)
        @step_count = attrs[:step_count]
        # binary string, such as '10010010'
        @bits = attrs[:steps].to_s(2).rjust(@step_count, '0')
        @command = SAMPLE_COMMAND_MAP[attrs[:sample]]
        @muted = attrs[:muted]
      end

      def play_at_step?(step)
        !@muted and @bits[step] == '1'
      end

      def command
        "  #{@command}\n"
      end

    end
  end
end
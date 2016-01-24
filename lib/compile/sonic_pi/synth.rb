module Compile
  module SonicPi
    class Synth

      SYNTH_MAP = {
        'SimpleSynth' => 'sine',
        'AMSynth' => 'saw',
        'FMSynth' => 'tri',
        'SubSynth' => 'saw',
        'PolySynth' => 'pinao'
      }

      def initialize(name, attrs)
        @synth = Synth.find_by_name(name)
        @pitches = attrs[:pitches]
        @step_count = @pitches.count
        @note_on_bits = attrs[:note_on_steps].to_s(2).rjust(@step_count, '0')
        @note_off_bits = attrs[:note_off_steps].to_s(2).rjust(@step_count, '0')

        @pi_synth = SYNTH_MAP[attrs[:constructor]]
      end



    end
  end
end
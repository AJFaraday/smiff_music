module Export
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
        @synth = ::Synth.find_by_name(name)
        @pitches = attrs[:pitches]
        @step_count = @pitches.length
        @note_on_bits = attrs[:note_on_steps].to_s(2).rjust(@step_count, '0')

        @pi_synth = SYNTH_MAP[@synth.constructor]
      end

      def start_note_at_step?(step)
        !@synth.muted and @note_on_bits[step] == '1'
      end

      def note_length_at_step(step)
        note_pitch = @synth.pitch_at_step(step)
        step += 1
        steps = 1
        until !@synth.active_at_step(step) or @synth.pitch_at_step(step) != note_pitch
          steps += 1
          step += 1
        end
        0.25 * steps
      end

      def pitch_at_step(step)
        @synth.pitch_at_step(step)
      end

      def amplitude
        @synth.volume.to_f / 100
      end

      def note_attributes(step)
        {sustain: note_length_at_step(step), release: 0.25, amp: amplitude}
      end

      def commands(step)
        result = "  use_synth :#{@pi_synth}\n"

        result << "  play #{pitch_at_step(step)}, #{note_attributes(step)}\n"
        result
      end

    end
  end
end
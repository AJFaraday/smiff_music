module Messages
  module Actions
    module SetSpeed

      def set_speed(args)
        bpm = args['bpm'][0].to_i
        if bpm > SystemSetting['max_bpm']
          return {
            response: 'failure',
            display: I18n.t(
              "actions.set_speed.too_fast",
              bpm: bpm,
              max: SystemSetting['max_bpm']
            )
          }
        end
        if bpm < SystemSetting['min_bpm']
          return {
            response: 'failure',
            display: I18n.t(
              "actions.set_speed.too_slow",
              bpm: bpm,
              min: SystemSetting['min_bpm']
            )
          }
        end

        SystemSetting['bpm'] = bpm
        PatternStore.modify_hash('bpm', bpm)
        return {
          response: 'success',
          display: I18n.t(
            'actions.set_speed.success',
            bpm: SystemSetting['bpm']
          )
        }
      end

    end
  end
end

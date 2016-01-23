module Messages
  module Actions
    module ShowSpeed

      def show_speed(args)
        return {
          response: 'success',
          display: I18n.t(
            'actions.show_speed.info',
            bpm: SystemSetting['bpm']
          )
        }
      end

    end
  end
end

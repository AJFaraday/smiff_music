module Messages
  module Actions
    module Stop

      def stop(params={})
        return {
          response: 'success',
          display: I18n.t('actions.stop.success'),
          javascript: 'Sound.stop();'
        }
      end

    end
  end
end

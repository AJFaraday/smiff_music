module Messages
  module Actions
    module Play

      def play(params={})
        return {
          response: 'success',
          display: I18n.t('actions.play.success'),
          javascript: 'Sound.play();'
        }
      end

    end
  end
end

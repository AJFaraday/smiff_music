module Messages
  module Actions
    module Help

      def help(args={})
        return {
          response: 'success',
          display: ContextHelp.guess(args['message'][0])
        }
      end

    end
  end
end

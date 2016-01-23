module Messages
  module Actions
    module ListDrums

      def list_drums(args)
        return {
          response: 'success',
          display: drum_list
        }
      end

      def drum_list
        result = ''
        names = Pattern.where(purpose: 'event').collect { |x| x.name }
        names.each { |x| result << "* #{x}\n" }
        return result
      end

    end
  end
end
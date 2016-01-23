module Messages
  module Actions
    module ListSynths

      def list_synths(args)
        return {
          response: 'success',
          display: synth_list
        }
      end

      def synth_list
        result = ''
        names = Synth.all.collect { |x| x.name }
        names.each { |x| result << "* #{x}\n" }
        return result
      end

    end
  end
end

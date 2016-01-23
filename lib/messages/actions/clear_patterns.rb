module Messages
  module Actions
    module ClearPatterns

      def clear_patterns(args)
        names = munge_list(args['pattern_names'])
        patterns = Pattern.where(name: names)
        synths = Synth.where(name: names)
        things = patterns + synths
        return pattern_not_found(names) unless things.any?
        patterns.each { |x| x.update_attribute(:bits, 0) }
        synths.each { |x| x.clear }
        return {
          response: 'success',
          display: I18n.t(
            "actions.clear.success.#{things.count > 1 ? 'other' : 'one'}",
            names: names.to_sentence(
              last_word_connector: ' and '
            )
          )
        }
      end

    end
  end
end

module Messages
  module Actions
    module SetParam

      def set_param(args)
        synth = Synth.find_by_name(args['synth'])
        parameter = args['parameter']
        value = args['value']
        if synth
          if synth.parameter_names.include?(parameter)
            synth.update_attributes(parameter => args['value'])
            if synth.valid?
              return parameter_set(parameter, synth, value)
            else
              return parameter_not_set(parameter, synth, value)
            end
          else
            return parameter_not_found(parameter, synth)
          end
        else
          return synth_not_found(args['synth'])
        end
      end

      def parameter_set(parameter, synth, value)
        {
          response: 'success',
          display: I18n.t(
            'actions.set_param.success',
            synth: synth.name,
            param: parameter,
            value: value
          )
        }
      end

      def parameter_not_set(parameter, synth, value)
        {
          response: 'failure',
          display: I18n.t(
            'actions.set_param.validation_failed',
            synth: synth.name,
            param: parameter,
            value: value,
            error: synth.errors[parameter][0]
          )
        }
      end

      def parameter_not_found(parameter, synth)
        return {
          response: 'failure',
          display: I18n.t(
            'messages.errors.parameter_not_found',
            synth: synth.name,
            parameter: parameter
          )
        }
      end

    end
  end
end

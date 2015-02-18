module Messages::Actions::ListParams

  def list_params(args)
    synth = Synth.find_by_name(args['synth'])
    if synth
      return {
        response: 'success',
        display: synth.parameter_list
      }
    else
      return {
        response: 'failure',
        display: I18n.t(
          'messages.errors.synth_not_found',
          synth: args['synth'][0]
        )
      }
    end
  end

end
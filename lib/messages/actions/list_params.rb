module Messages::Actions::ListParams

  def list_params(args)
    synth = Synth.find_by_name(args['synth'])
    if synth
      return {
        response: 'success',
        display: synth.parameter_list
      }
    else
      return synth_not_found(args['synth'][0])
    end
  end

end
module Messages::Actions::DescribeSynth

  def describe_synth(args)
    synth = Synth.find_by_name(args['synth'])
    if synth
      return {
        response: 'success',
        display: synth.description
      }
    else
      return {
        response: 'failure',
        display: I18n.t(
          'actions.describe_synth.synth_not_found',
          synth: args['synth']
        )
      }
    end
  end

end
module Messages::Actions::DescribeSynth

  def describe_synth(args)
    synth = Synth.find_by_name(args['synth'])
    if synth
      return {
        response: 'success',
        display: synth.description
      }
    else
      return synth_not_found(args['synth'][0])
    end
  end

end
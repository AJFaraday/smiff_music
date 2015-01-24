module Messages::Actions::SetSynth

  def set_synth(args)
    synth_name = args['synth'][0]
    synth = Synth.find_by_name(synth_name)
    if synth
      return {
        response: 'success',
        display: I18n.t(
          'actions.set_synth.synth_set',
          synth: synth_name
        ),
        session: { synth: synth_name }
      }
    else
      return {
        response: 'failure',
        display: I18n.t(
          'actions.set_synth.synth_not_found',
          synth: synth_name
        )
      }
    end
  end

end
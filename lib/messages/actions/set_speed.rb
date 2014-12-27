module Messages::Actions::SetSpeed

  def set_speed(args)
    bpm = args['bpm'][0].to_i
    SystemSetting['bpm'] = bpm
    return {
      response: 'success',
      display: I18n.t(
        'actions.set_speed.success',
        bpm: SystemSetting['bpm']
      )
    }
  end

end
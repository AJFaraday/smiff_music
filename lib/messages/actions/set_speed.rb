module Messages::Actions::SetSpeed

  def set_speed(args)
    SystemSetting['bpm'] = args['bpm']
    return {
      response: 'success',
      display: I18n.t(
        'actions.set_speed.success',
        bpm: SystemSetting['bpm']
      )
    }
  end

end
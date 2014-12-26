module Messages::Actions::SpeedUp

  def speed_up(args)
    SystemSetting['bpm'] = SystemSetting['bpm'].to_i + 5
    return {
      response: 'success',
      display: I18n.t(
        'actions.set_speed.success',
        bpm: SystemSetting['bpm']
      )
    }
  end

end
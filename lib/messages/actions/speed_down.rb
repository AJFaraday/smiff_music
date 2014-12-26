module Messages::Actions::SpeedDown

  def speed_down(args)
    SystemSetting['bpm'] = SystemSetting['bpm'].to_i - 5
    return {
      response: 'success',
      display: I18n.t(
        'actions.set_speed.success',
        bpm: SystemSetting['bpm']
      )
    }
  end

end
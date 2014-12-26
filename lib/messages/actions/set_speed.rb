module Messages::Actions::SetSpeed

  def set_speed(args)
    puts args.inspect
    SystemSetting['bpm'] = args['bpm']
    return {
      response: 'success',
      display: I18n.t(
        'actions.set_speed.success',
        bpm: args['bpm']
      )
    }
  end

end
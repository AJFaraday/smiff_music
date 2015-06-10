module Messages::Actions::Help

  def help(args={})
    return {
      response: 'success',
      display: ContextHelp.guess(args['message'][0])
    }
  end

end
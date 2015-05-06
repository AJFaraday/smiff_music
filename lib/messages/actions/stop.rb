module Messages::Actions::Stop

  def stop(params={})
    return {
      response: 'success',
      display: I18n.t('actions.stop.success'),
      javascript: 'Sound.stop();'
    }
  end

end

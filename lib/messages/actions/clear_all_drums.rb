module Messages::Actions::ClearAllDrums

  # note: this may be 'antisocial' when there is more than one user
  def clear_all_drums(args)
    # todo when there are non-drum patterns, distinguish between drums and melodic.
    Pattern.update_all(bits: 0)
    PatternStore.hash['patterns'].each{|k,value| value[:steps] = 0 if value.is_a?(Hash)}
    PatternStore.version += 1

    return {
      response: 'success',
      display: I18n.t('actions.clear_all_drums.success')
    }
  end

end
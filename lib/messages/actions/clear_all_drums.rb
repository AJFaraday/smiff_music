module Messages::Actions::ClearAllDrums

  # note: this may be 'antisocial' when there is more than one user
  def clear_all_drums(args)
    # todo when there are non-drum patterns, distinguish between drums and melodic.
    Pattern.all.each{|x| x.update_attribute(:pattern_indexes, [])}

    return {
      response: 'success',
      display: I18n.t('actions.clear_all_drums.success')
    }
  end

end
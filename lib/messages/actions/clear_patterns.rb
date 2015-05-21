module Messages::Actions::ClearPatterns


  def clear_patterns(args)
    names = munge_list(args['pattern_names'])
    patterns = Pattern.all.select{|p|names.include?(p.name)}
    synths = Synth.all.select{|s|names.include?(s.name)}
    things = patterns + synths
    return pattern_not_found(names) unless things.any?
    patterns.each{|x| x.clear}
    synths.each{|x| x.clear }
    return {
      response: 'success',
      display: I18n.t(
        "actions.clear.success.#{things.count > 1 ? 'other' : 'one'}",
        names: names.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
  end

end

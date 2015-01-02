module Messages::Actions::ShowAllDrums

  attr_accessor :patterns

  def show_all_drums(args)
    self.patterns = Pattern.all
    return {
      response: 'success',
      display: self.pattern_diagram # defined in /messages/actions/show.rb
    }
  end

end
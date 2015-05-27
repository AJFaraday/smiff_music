class MessageFormat < InMemoryBase


  def regex
    Regexp.new(super)
  end


end

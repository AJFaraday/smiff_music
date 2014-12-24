class MessageFormat < ActiveRecord::Base

  serialize :variables

  def regex
    Regex.new(super)
  end

end

class MessageFormat < ActiveRecord::Base

  serialize :variables

  def regex
    Regexp.new(super)
  end


end

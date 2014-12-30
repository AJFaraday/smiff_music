class HelpController < ApplicationController

  def index
    @pages = Help.pages
  end

end

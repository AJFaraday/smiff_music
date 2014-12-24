class MessageController < ApplicationController

  def create
    message = Message.parse(params[:message])
    @response = message.run
  end

end

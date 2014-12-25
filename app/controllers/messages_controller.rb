class MessagesController < ApplicationController

  def create
    message = Message.parse(params[:message])
    @response = message.run
    render text: @response.to_json
  end

end

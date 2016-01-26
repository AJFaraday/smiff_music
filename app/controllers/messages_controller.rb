class MessagesController < ApplicationController

  def create
    message = Message.parse(params[:message], extract_action_parameters)
    @response = message.run
    if @response[:session] and @response[:session].is_a?(Hash)
      @response[:session].each { |key, value| session[key] = value }
    end
    sanitise_file_name
    render text: @response.to_json
  end

  protected

  def sanitise_file_name
    if @response[:file]
      @response[:file] = @response[:file].split('/public')[-1]
    end
  end

  def extract_action_parameters
    defaults = YAML.load_file(File.join(Rails.root, 'config', 'session_defaults.yml'))
    params_from_session = {}
    defaults.keys.each { |k| params_from_session[k] = session[k] if session[k] }
    return defaults.merge(params_from_session)
  end

end

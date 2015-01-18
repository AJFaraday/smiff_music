class PatternsController < ApplicationController

  helper SynthsHelper

  def index
    respond_to do |format|
      format.html do
        @patterns = Pattern.all
      end
      format.json do
        if params[:version] and params[:version].to_i >= PatternStore.version
          # in this case the client already has the most recent version of the patterns
          # this avoids unnecessary data being passed down the line and
          # unnecessary modifications being made client-side
          render nothing: true
        else
          render json: PatternStore.hash.to_json
        end
      end
    end
  end

end
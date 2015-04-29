class PatternsController < ApplicationController

  helper SynthsHelper

  def index
    respond_to do |format|
      format.html do
        @patterns = Pattern.all
      end
      format.json do
        render json: PatternStore.hash_for_version(params[:version].to_i + 1).to_json
      end
    end
  end

end

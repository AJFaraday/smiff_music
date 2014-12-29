class PatternsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html do
        @patterns = Pattern.all
      end
      format.json do
        if params[:version] and params[:version].to_i < PatternStore.version
          render json: PatternStore.hash.to_json
        else
          # in this case the client already has the most recent version of the patterns
          # this avoids unnecessary data being passed down the line and
          # unnecessary modifications being made client-side
          render nothing: true
        end
      end
    end
  end

  def show
    @pattern = Pattern.find(params[:id])
    respond_to do |format|
      format.html do
        #todo 
      end
      format.json do
        if @pattern
          render json: @pattern.to_hash
        else
          render json: {error: I18n.t('activerecord.errors.pattern.not_found')}
        end 
      end
    end
  end

end

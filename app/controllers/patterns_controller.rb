class PatternsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html do
        #todo 
      end
      format.json do 
        render json: Pattern.to_hash.to_json
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

class InfoPanelController < ApplicationController
  def show
    @cultivar = Cultivar.find(params[:id])
    render json: @cultivar
  end

  def hide
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @cultivar = Cultivar.find(params[:id])
    @current_cultivar = @cultivar
    respond_to do |format|
      format.turbo_stream
    end
  end 

  def destroy
  end 

end

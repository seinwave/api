class InfoPanelController < ApplicationController
  def hide
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    if request.referer == nil
      puts request.referer
      redirect_to controller: 'map', action: 'show', id: params[:id]
    else
      @cultivar = Cultivar.find(params[:id])
      @current_cultivar = @cultivar
      respond_to do |format|
        format.turbo_stream
      end
    end
  end



end
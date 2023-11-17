class InfoPanelController < ApplicationController
  def hide
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    if request.referer != root_url
      redirect_to root_url
    else
      @cultivar = Cultivar.find(params[:id])
      @current_cultivar = @cultivar
      respond_to do |format|
        format.turbo_stream
      end
    end
  end



end
class InfoPanelController < ApplicationController
  def show
    @cultivar = Cultivar.find(params[:id])
    render json: @cultivar
  end

  def hide
  end
end

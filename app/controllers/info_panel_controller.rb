class InfoPanelController < ApplicationController
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
  
  def list_results(results)
    @cultivars = results
    respond_to do |format|
      format.turbo_stream
    end
  end


end

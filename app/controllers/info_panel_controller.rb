class InfoPanelController < ApplicationController
  def hide
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    #todo:  ADD HANDLING FOR HTML RESPONSES - all you need is to create a view for the html, i think
    @cultivar = Cultivar.find(params[:id])
    @current_cultivar = @cultivar
    respond_to do |format|
      format.turbo_stream
      
    end
  end



end

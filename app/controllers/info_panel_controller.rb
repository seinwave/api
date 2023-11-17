class InfoPanelController < ApplicationController
  def hide
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    puts "CREATING INFO PANEL"
    
    binding.pry
    @cultivar = Cultivar.find(params[:id])
    @current_cultivar = @cultivar
    respond_to do |format|
      format.turbo_stream
    end
  end



end

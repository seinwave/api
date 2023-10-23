class CultivarsController < ApplicationController
  def index
    @cultivars = Cultivar.all
  end

  def show
    @cultivar = Cultivar.find(params[:id])
    set_current_cultivar(@cultivar)
    render json: @cultivar
  end

  def hide
    session[:cultivar_id] = nil
  end 

  def set_current_cultivar(cultivar)    
    session[:cultivar_id] = cultivar.id
  end 

  def current_cultivar
    return session[:cultivar_id] if session[:cultivar_id]
  end

end

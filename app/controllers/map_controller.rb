class MapController < ApplicationController
  def show
      @plants = Plant.all
  end

  def current_cultivar
    return session[:cultivar_id] if session[:cultivar_id]
  end

end

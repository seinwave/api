class MapController < ApplicationController
  def show
      @plants = Plant.all
  end

end

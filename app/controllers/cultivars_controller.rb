class CultivarsController < ApplicationController
  def index
    @cultivars = Cultivar.all
  end
end

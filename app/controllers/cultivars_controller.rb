class CultivarsController < ApplicationController
  def index
    @cultivars = Cultivar.all
  end

  def show
  end
end

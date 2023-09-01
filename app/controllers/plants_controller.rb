# frozen_string_literal: true

class PlantsController < ApplicationController
  def index
    @plants = Plant.all
    @cultivars = Cultivar.all
    @cultivargroups = CultivarGroup.all

    render json: { plants: @plants, cultivars: @cultivars, cultivargroups: @cultivargroups }
  end
end

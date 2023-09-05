# frozen_string_literal: true

class CultivarsController < ActionController::Base

  def index
    @cultivars = Cultivar.search(params[:search])
  end

  # def params
  #   params.require(:cultivar).permit(:search)
  # end
end

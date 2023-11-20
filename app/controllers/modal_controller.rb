class ModalController < ApplicationController

  def open
    respond_to do |format|
        format.turbo_stream
    end  
  end

end

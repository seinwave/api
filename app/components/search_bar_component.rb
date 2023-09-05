# frozen_string_literal: true

class SearchBarComponent < ApplicationComponent
  def initialize(query:)
    @query = query
  end

end

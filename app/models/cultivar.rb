# frozen_string_literal: true

class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants
end

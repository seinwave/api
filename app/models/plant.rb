# frozen_string_literal: true

class Plant < ApplicationRecord
  enum status: { groundcover: 0, shrub: 1, rambling: 2, climbing: 3 }
  belongs_to :cultivar
end

# frozen_string_literal: true

class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants

  def self.search(search)
    if search
      where(["name LIKE ?", "%#{search}%"])
    end
  end
end

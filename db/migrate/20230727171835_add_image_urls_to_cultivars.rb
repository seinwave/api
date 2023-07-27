class AddImageUrlsToCultivars < ActiveRecord::Migration[7.0]
  def change
    add_column :cultivars, :image_url, :text, default: ''
  end
end

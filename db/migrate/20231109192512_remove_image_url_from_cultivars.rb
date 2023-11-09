class RemoveImageUrlFromCultivars < ActiveRecord::Migration[7.0]
  def change
    remove_column :cultivars, :image_url, :string
  end
end

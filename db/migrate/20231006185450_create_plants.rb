class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.float "latitude"
      t.float "longitude"
      t.boolean "is_deleted"
      t.integer "form", default: 0, null: false
      t.bigint "cultivar_id", null: false
      t.bigint "sector_id", null: false
      t.index ["cultivar_id"], name: "index_plants_on_cultivar_id"
      t.index ["sector_id"], name: "index_plants_on_sector_id"

      t.timestamps
    end
  end
end

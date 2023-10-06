class CreateSectors < ActiveRecord::Migration[7.0]
  def change
    create_table :sectors do |t|
      t.string "name", null: false
      t.jsonb "coordinates", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "geojson_string"

      t.timestamps
    end
  end
end

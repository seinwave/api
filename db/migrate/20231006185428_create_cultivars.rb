class CreateCultivars < ActiveRecord::Migration[7.0]
  def change
    create_table :cultivars do |t|
      t.string "name", null: false
      t.string "breeder"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "description"
      t.boolean "is_deleted", default: false, null: false
      t.integer "bred_year"
      t.integer "introduced_year"
      t.integer "cultivar_group_id", null: false

      t.timestamps
    end
  end
end

class CreateCultivarGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :cultivar_groups do |t|
      t.string "name", null: false
      t.string "description"
      t.integer "category_id", null: false

      t.timestamps
    end
  end
end

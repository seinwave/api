class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, unique: true, null: false
      t.string :description 

      t.timestamps
    end
  end
end

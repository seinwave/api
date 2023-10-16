class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :favoriter_id
      t.integer :favorite_cultivar_id

      t.timestamps
    end
    add_index :favorites, :favoriter_id
    add_index :favorites, :favorite_cultivar_id
    add_index :favorites, [:favoriter_id, :favorite_cultivar_id], unique: true
  end
end

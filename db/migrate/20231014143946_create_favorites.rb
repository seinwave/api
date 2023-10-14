class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :cultivar_id

      t.timestamps
    end
    add_index :favorites, :user_id
    add_index :favorites, :cultivar_id
    add_index :favorites, [:user_id, :cultivar_id], unique: true
  end
end

class CreateCultivarGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :cultivar_groups do |t|

      t.timestamps
    end
  end
end

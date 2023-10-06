class CreateCultivars < ActiveRecord::Migration[7.0]
  def change
    create_table :cultivars do |t|

      t.timestamps
    end
  end
end

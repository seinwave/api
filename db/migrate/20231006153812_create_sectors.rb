class CreateSectors < ActiveRecord::Migration[7.0]
  def change
    create_table :sectors do |t|

      t.timestamps
    end
  end
end

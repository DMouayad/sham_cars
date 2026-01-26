
class CreateVehicleImages < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_images do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :url, null: false
      t.string :alt_text
      t.integer :position, default: 0
      t.boolean :primary, default: false

      t.timestamps
    end

    add_index :vehicle_images, [:vehicle_id, :position]
  end
end

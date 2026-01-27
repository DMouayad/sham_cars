class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :logo
      t.string :country
      t.text :description
      t.string :website

      t.timestamps
    end

    add_index :brands, :slug, unique: true
    add_index :brands, :name
  end
end

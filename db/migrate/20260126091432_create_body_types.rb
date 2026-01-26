class CreateBodyTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :body_types do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :icon
      t.text :description

      t.timestamps
    end

    add_index :body_types, :slug, unique: true
  end
end

class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.integer :rating, null: false
      t.string :title
      t.text :body, null: false

      t.integer :status, default: 0, null: false  # pending, approved, rejected

      t.timestamps
    end

    add_index :reviews, :status
    add_index :reviews, [:vehicle_id, :status]
    add_index :reviews, [:user_id, :vehicle_id], unique: true  # One review per user per vehicle
  end
end

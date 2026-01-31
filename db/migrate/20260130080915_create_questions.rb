class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :body, null: false

      t.references :user, null: false, foreign_key: true

      t.integer :status, null: false, default: 1
      t.integer :views_count, null: false, default: 0
      t.integer :answers_count, null: false, default: 0

      t.timestamps
    end

    add_index :questions, :status
    add_index :questions, :created_at
  end
end

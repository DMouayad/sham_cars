class AddThemeToUsers < ActiveRecord::Migration[8.1]
  def change
      add_column :users, :theme, :integer, default: 5
  end
end

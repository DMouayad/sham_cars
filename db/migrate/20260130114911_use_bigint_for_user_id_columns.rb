class UseBigintForUserIdColumns < ActiveRecord::Migration[8.1]
  def up
    convert_user_id_to_bigint(:events)
    convert_user_id_to_bigint(:sessions)
    convert_user_id_to_bigint(:recovery_codes)
    convert_user_id_to_bigint(:sign_in_tokens)
  end

  def down
    # Optional: if you really need rollback
    convert_user_id_to_integer(:events)
    convert_user_id_to_integer(:sessions)
    convert_user_id_to_integer(:recovery_codes)
    convert_user_id_to_integer(:sign_in_tokens)
  end

  private

  def convert_user_id_to_bigint(table)
    return unless column_exists?(table, :user_id)

    # Drop FK first (Postgres requires matching types)
    remove_foreign_key(table, :users) if foreign_key_exists?(table, :users)

    # Convert column type
    change_column table, :user_id, :bigint, using: "user_id::bigint"

    # Re-add FK (if you want strict integrity)
    add_foreign_key table, :users unless foreign_key_exists?(table, :users)
  end

  def convert_user_id_to_integer(table)
    return unless column_exists?(table, :user_id)

    remove_foreign_key(table, :users) if foreign_key_exists?(table, :users)
    change_column table, :user_id, :integer, using: "user_id::integer"
    add_foreign_key table, :users unless foreign_key_exists?(table, :users)
  end
end

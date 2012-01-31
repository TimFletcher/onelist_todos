class ChangeColumnName < ActiveRecord::Migration
  def up
    rename_column :lists, :hash, :hash_token
  end

  def down
    rename_column :lists, :hash_token, :hash
  end
end

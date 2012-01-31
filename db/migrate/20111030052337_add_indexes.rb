class AddIndexes < ActiveRecord::Migration
  def up
    add_index :lists, :user_id, :name => 'user_id_lists_ix'
    add_index :list_items, :list_id, :name => 'user_id_list_items_ix'
    add_index :payment_notifications, :user_id, :name => 'payment_notifications_user_id_ix'
  end

  def down
    remove_index(:lists, :name => 'user_id_lists_ix')
    remove_index(:list_items, :name => 'user_id_list_items_ix')
    remove_index(:payment_notifications, :name => 'payment_notifications_user_id_ix')
  end
end

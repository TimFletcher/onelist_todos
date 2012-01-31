class ChangeDefaultOnListItemsCompleted < ActiveRecord::Migration
  def up
    change_column_default :list_items, :complete, false
  end

  def down
    change_column_default :list_items, :complete, nil
  end
end
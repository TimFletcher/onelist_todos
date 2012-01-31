class AddTasksCountToList < ActiveRecord::Migration

  def change
    add_column :lists, :list_items_count, :integer, :default => 0
  end
end

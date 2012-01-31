class AddTasksCompletedCountToList < ActiveRecord::Migration
  def change
    add_column :lists, :list_items_completed_count, :integer, :default => 0
  end
end

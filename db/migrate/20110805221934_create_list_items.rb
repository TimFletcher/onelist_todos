class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.integer :list_id
      t.string :text
      t.boolean :complete

      t.timestamps
    end
  end
end

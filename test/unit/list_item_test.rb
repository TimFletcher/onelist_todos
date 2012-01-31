require 'test_helper'

class ListItemTest < ActiveSupport::TestCase

  setup :initialise

  # Surely this should be a unit test for the model??????
  test "Cannot mass assign to protected fields" do
    list_item = ListItem.new(:list_id => 1,
                             :text => 'stuff',
                             :complete => true)
    assert_nil list_item.list_id, "list_id was assigned a value"
    assert_not_nil list_item.text, "text wasn't assigned a value"
    assert_not_equal list_item.complete, false, "complete was not assigned a value"
  end

  test "List item is not valid without text" do
    @list_item.text = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      @list_item.save!
    end
  end
  
  test "update counter cache on save" do
    assert_difference('@list_item.list.list_items_completed_count', +1) do
      @list_item.toggle! :complete
    end
  end
  
  test "update counter cache on delete" do
    @list_item.list.list_items_completed_count = 1
    assert_difference('@list_item.list.list_items_completed_count', -1) do
      @list_item.destroy
    end
  end

  private

  def initialise
    @list_item = Factory.create(:list_item)
  end
end


require 'test_helper'

class ListTest < ActiveSupport::TestCase

  setup :initialise

  test "Cannot mass assign to protected fields" do
    list = List.new(:list_items_count => 1,
                    :list_items_completed_count => 1,
                    :name => 'Tim',
                    :hash_token => 'empty')
    assert_equal list.list_items_count, 0, "list_items_count was assigned a value"
    assert_equal list.list_items_completed_count, 0, "list_items_completed_count was assigned a value"
    assert_nil list.user_id, "user_id was assigned a value"
    assert_nil list.hash_token, "hash_token was assigned a value"
  end

  test "List is not valid without a user" do
    @list.user = nil
    assert !@list.save, "Saved the list without a user"
  end

  test "Automatically generates a hash" do
    @list.save
    assert_not_nil @list.hash_token, "A hash token was not generated"
  end

  test "Generates a unique hash" do
    list_1 = Factory.create(:list)
    list_2 = Factory.create(:list)
    assert_not_equal list_1.hash_token, list_2.hash_token, "The hash tokens were not unique"
  end

  private

  def initialise
    @list = Factory.build(:list)
  end
end


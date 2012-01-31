class ListItem < ActiveRecord::Base
  after_destroy :update_counter_cache
  after_save    :update_counter_cache
  attr_accessible :text, :complete
  attr_readonly :list_items_completed_count
  default_scope :order => 'created_at ASC'
  belongs_to :list, :counter_cache => true
  validates :text, :presence => true

  def update_counter_cache
    self.list.list_items_completed_count = self.list.user.list_items
      .where(:list_id => self.list, :complete => true).size
    self.list.save
  end
end


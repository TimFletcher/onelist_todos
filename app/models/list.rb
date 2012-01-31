class List < ActiveRecord::Base
  attr_accessible :name
  before_create { generate_hash(:hash_token) }
  default_scope :order => 'created_at ASC'
  has_many :list_items, :dependent => :delete_all
  belongs_to :user
  validates :user_id, :presence => true
  validates :name, :presence => true

  #def to_param
    #"#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  #end

  def generate_hash(column)
    begin
      self[column] = SecureRandom.urlsafe_base64(20)
    end while List.exists?(column => self[column]) # Loop to make sure it's unique
  end
end


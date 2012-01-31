class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  before_create { generate_token(:auth_token) }
  has_many :lists, :dependent => :delete_all
  has_many :list_items, :through => :lists
  has_secure_password
  validates :email, :presence => true,
                    :uniqueness => true,
                    :email_format => { :message => I18n.t("validation.email_format") }
  validates :password, :presence => true,
                       :on => :create
  validates :password_confirmation, :presence => true,
                                    :on => :create

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64 # Random string via ActiveSupport
    end while User.exists?(column => self[column]) # Loop to make sure it's unique
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def within_trial?
    return (self.created_at + OneListRails::Application.config.trial_period) > Time.now
  end
end

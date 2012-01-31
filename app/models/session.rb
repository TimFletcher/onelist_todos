class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :password

  validates :email, :presence => true, 
                    :email_format => { :message => I18n.t("validation.email_format") }
  validates :password, :presence => true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def authenticate?
    user = User.where(:email => self.email).first
    return user if user && user.authenticate(self.password)
    self.errors.add :base, 'Incorrect email and/or password'
    nil
  end
end

# http://jeffgardner.org/2011/05/26/adding-activerecord-style-callbacks-to-activeresource-models/
# http://railscasts.com/episodes/219-active-model
# http://forrst.com/posts/Contact_form_using_Active_Model-u1G
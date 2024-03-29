class PasswordReset
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email

  validates :email,
            :presence => true, 
            :email_format => { :message => I18n.t("validation.email_format") }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
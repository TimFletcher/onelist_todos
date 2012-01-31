class PaymentNotification < ActiveRecord::Base
  belongs_to :user
  serialize :params
  after_create :mark_user_as_paid

  private

  def mark_user_as_paid
    if status == 'Completed'
      user.update_attribute(:paid, true)
    end
  end
end

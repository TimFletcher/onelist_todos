class PaymentNotificationsController < ApplicationController
  before_filter :http_basic_authentication, :except => [:create] if Rails.env.staging? # Exempt from http basic auth
  before_filter :authenticate, :only => [:new, :success]
  # skip_before_filter
  protect_from_forgery :except => [:create]

  def new
    redirect_to lists_path if authenticated_user.paid
  end

  def create
    if params[:payment_status] == 'Completed' && params[:shared_secret] == OneListRails::Application.config.shared_secret
      PaymentNotification.create!(:params => params,
                                  :user_id => params[:invoice],
                                  :status => params[:payment_status],
                                  :transaction_id => params[:txn_id])
    end
    render :nothing => true
  end
end

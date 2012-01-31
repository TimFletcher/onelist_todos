class SessionsController < ApplicationController

  before_filter :redirect_authenticated_user, :except => :destroy
  respond_to :html

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.valid?
      user = @session.authenticate?
      if user
        sign_in user
        redirect_back_or_to lists_path
      else
        render :new
      end
    else
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url, :notice => "Logged out!"
  end
end

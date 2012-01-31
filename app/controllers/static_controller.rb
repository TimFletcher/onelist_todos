class StaticController < ApplicationController
  def home
    redirect_authenticated_user
  end
end

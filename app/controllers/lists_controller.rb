class ListsController < ApplicationController
  before_filter :authenticate
  respond_to :html, :js, :json

  def index
    @lists = @current_user.lists
    @list = List.new
  end

  def create
    @list = @current_user.lists.create(params[:list])
  end

  def show
    @list = @current_user.lists.find(params[:id])
    @list_item = @list.list_items.build
  end

  def update
    # if List.exists?(:id => params[:id], :user_id => @current_user.id) # Edge case? Handle this with JS
    # Scope through the user???
    @list = List.update(params[:id], params[:list]) # Error handling necessary?
    # end
    render :nothing => true
  end

  def destroy
    @list = @current_user.lists.find(params[:id]).destroy
    redirect_to lists_path, :notice => "#{@list.name} list deleted"
  end
end

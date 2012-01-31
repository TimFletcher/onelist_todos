class ListItemsController < ApplicationController
  before_filter :authenticate, :except => [:new_via_hash_token, :create_via_hash_token]
  respond_to :html, :js, :json

  def create
    @list = @current_user.lists.find(params[:list_id])
    @list_item = @list.list_items.create(params[:list_item])
  end

  def update
    @list_item = @current_user.list_items.find(params[:id])
    @list_item.update_attributes(params[:list_item]) unless @list_item.text == params[:list_item][:text]
  end

  def new_via_hash_token
    @list = List.find_by_hash_token(params[:hash_token]) || not_found
    @list_item = @list.list_items.build(params[:list_item])
  end

  def create_via_hash_token
    @list = List.find_by_hash_token(params[:hash_token]) || not_found
    @list_item = @list.list_items.create(params[:list_item])
  end

  def toggle_checkoff
    @current_user.list_items.find(params[:id]).toggle! :complete
    render :nothing => true
  end

  def destroy
    @list_item = @current_user.list_items.find(params[:id]).destroy
  end
end

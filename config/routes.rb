OneListRails::Application.routes.draw do

  root :to => "static#home"

  get  "login"                       => "sessions#new",                  :as => "log_in"
  get  "logout"                      => "sessions#destroy",              :as => "log_out"
  get  "register"                    => "users#new",                     :as => "register"
  get  "password_reset"              => "users#password_reset_form",     :as => "password_reset_form"
  post "password_reset"              => "users#password_reset",          :as => "password_reset"
  post "password_reset_success"      => "users#password_reset_success",  :as => "password_reset_success"
  get  "password_reset_token/:token" => "users#password_reset_token",    :as => "password_reset_token"
  get  "password_change"             => "users#password_change_form",    :as => "password_change_form"
  put  "password_change"             => "users#password_change",         :as => "password_change"
  get  "payments"                    => "payment_notifications#new",     :as => "payment_notifications_new"
  post "payments"                    => "payment_notifications#create",  :as => "payment_notifications"
  get  "payments/success"            => "payment_notifications#success", :as => "payment_notifications_success"

  resources :users,    :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy] # Should this be resource?
  resources :lists do # :except [:new, :edit] - How to remove these?
    resources :list_items, :only => [:create, :destroy, :update], :shallow => true
  end
  put  "list_items/toggle_checkoff/:id" => "list_items#toggle_checkoff",       :as => 'toggle_checkoff'
  get  ":hash_token"                    => "list_items#new_via_hash_token",    :as => 'new_via_hash_token'
  post ":hash_token"                    => "list_items#create_via_hash_token", :as => 'create_via_hash_token'
end

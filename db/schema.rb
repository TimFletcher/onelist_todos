# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111030052337) do

  create_table "list_items", :force => true do |t|
    t.integer  "list_id"
    t.string   "text"
    t.boolean  "complete",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_items", ["list_id"], :name => "user_id_list_items_ix"

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "hash_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "list_items_count",           :default => 0
    t.integer  "list_items_completed_count", :default => 0
  end

  add_index "lists", ["user_id"], :name => "user_id_lists_ix"

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_notifications", ["user_id"], :name => "payment_notifications_user_id_ix"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "paid",                   :default => false
  end

end

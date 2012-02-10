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

ActiveRecord::Schema.define(:version => 20120210010252) do

  create_table "categories", :force => true do |t|
    t.string   "theshiz"
    t.integer  "contents_count",        :default => 0
    t.integer  "active_contents_count", :default => 0
    t.boolean  "is_nsfw"
    t.boolean  "in_recycling",          :default => false
    t.integer  "it_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "comments", :force => true do |t|
    t.text     "theshiz"
    t.integer  "vote",         :default => 0
    t.boolean  "in_recycling", :default => false
    t.integer  "user_id"
    t.integer  "content_id"
    t.integer  "tone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "content_types", :force => true do |t|
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "theshiz"
    t.string   "file_type"
    t.string   "file_name"
    t.binary   "image_data",            :limit => 16777215
    t.string   "type"
    t.integer  "vote",                                      :default => 0
    t.integer  "comments_count",                            :default => 0
    t.integer  "active_comments_count",                     :default => 0
    t.boolean  "in_recycling",                              :default => false
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "its", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "categories_count", :default => 0
    t.boolean  "locked"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "type_id"
    t.string   "type_name"
    t.integer  "parent_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "type_id"
    t.string   "type_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tones", :force => true do |t|
    t.string   "mood"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                           :default => "", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "vote_logs", :force => true do |t|
    t.integer  "type_id"
    t.string   "type_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

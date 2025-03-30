# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2012_02_24_205237) do

  create_table "categories", force: :cascade do |t|
    t.string "theshiz"
    t.integer "contents_count", default: 0
    t.integer "active_contents_count", default: 0
    t.boolean "is_nsfw"
    t.boolean "in_recycling", default: false
    t.integer "it_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip"
    t.integer "click_count", default: 0
    t.index ["it_id"], name: "index_categories_on_it_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "theshiz"
    t.boolean "in_recycling", default: false
    t.integer "user_id"
    t.integer "content_id"
    t.integer "tone_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip"
    t.integer "comment_number", default: 0
    t.index ["content_id"], name: "index_comments_on_content_id"
    t.index ["tone_id"], name: "index_comments_on_tone_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "content_types", force: :cascade do |t|
    t.string "type_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.text "theshiz"
    t.string "file_type"
    t.string "file_name"
    t.binary "image_data", limit: 10485760
    t.string "type"
    t.integer "comments_count", default: 0
    t.integer "active_comments_count", default: 0
    t.boolean "in_recycling", default: false
    t.integer "category_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip"
    t.integer "click_count", default: 0
    t.index ["category_id"], name: "index_contents_on_category_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "its", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "categories_count", default: 0
    t.boolean "locked"
    t.boolean "is_default"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end

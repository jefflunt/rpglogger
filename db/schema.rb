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

ActiveRecord::Schema.define(:version => 20111112175831) do

  create_table "games", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_books", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "game_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "section_properties", :force => true do |t|
    t.integer "section_id", :null => false
    t.string  "name",       :null => false
    t.string  "data_type",  :null => false
    t.integer "sort_order", :null => false
    t.string  "entry_type"
  end

  create_table "sections", :force => true do |t|
    t.integer "log_book_id", :null => false
    t.string  "name",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_object_properties", :force => true do |t|
    t.integer  "world_object_id",     :null => false
    t.integer  "section_property_id", :null => false
    t.integer  "integer_value"
    t.boolean  "boolean_value"
    t.string   "string_value"
    t.text     "text_value"
    t.datetime "datetime_value"
    t.string   "lookup_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "world_objects", :force => true do |t|
    t.string  "type",             :null => false
    t.integer "section_id",       :null => false
    t.integer "parent_object_id"
    t.string  "name",             :null => false
  end

end

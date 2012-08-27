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

ActiveRecord::Schema.define(:version => 20120728154134) do

  create_table "games", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_books", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.string   "title",                          :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "game_name"
    t.boolean  "is_public",   :default => false
    t.datetime "archived_at"
  end

  create_table "section_properties", :force => true do |t|
    t.integer  "section_id",  :null => false
    t.string   "name",        :null => false
    t.string   "data_type",   :null => false
    t.integer  "sort_order",  :null => false
    t.datetime "archived_at"
  end

  create_table "sections", :force => true do |t|
    t.integer  "log_book_id", :null => false
    t.string   "name",        :null => false
    t.datetime "archived_at"
  end

  create_table "shares", :force => true do |t|
    t.integer "log_book_id"
    t.integer "user_id"
    t.string  "role",        :default => "editor"
  end

  add_index "shares", ["log_book_id", "user_id"], :name => "index_shares_on_log_book_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "world_object_properties", :force => true do |t|
    t.integer  "world_object_id",     :null => false
    t.integer  "section_property_id", :null => false
    t.integer  "integer_value"
    t.boolean  "boolean_value"
    t.string   "string_value"
    t.text     "text_value"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "world_objects", :force => true do |t|
    t.integer  "section_id",  :null => false
    t.string   "name",        :null => false
    t.datetime "archived_at"
  end

end

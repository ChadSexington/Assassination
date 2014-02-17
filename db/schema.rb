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

ActiveRecord::Schema.define(:version => 20140217164453) do

  create_table "assignments", :force => true do |t|
    t.integer  "player_id"
    t.text     "elim_location"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "round_id"
    t.boolean  "active",        :default => false
    t.integer  "target_id"
  end

  create_table "deaths", :force => true do |t|
    t.integer  "player_id"
    t.string   "assassin_id"
    t.text     "recap"
    t.text     "location"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "kills", :force => true do |t|
    t.integer  "player_id"
    t.integer  "deceased_id"
    t.text     "recap"
    t.text     "location"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "news_posts", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.string   "author"
    t.boolean  "public"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "irc_nick"
    t.text     "notes"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "hashed_password"
    t.string   "salt"
    t.text     "dna_times"
    t.boolean  "admin",              :default => false
    t.string   "confirmation_code"
    t.boolean  "confirmed",          :default => false
    t.string   "nickname"
    t.boolean  "banned",             :default => false
    t.integer  "wins",               :default => 0
  end

  create_table "rounds", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "active"
    t.text     "players"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

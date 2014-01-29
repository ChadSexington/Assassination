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

ActiveRecord::Schema.define(:version => 20140129155155) do

  create_table "assignments", :force => true do |t|
    t.integer  "player_id"
    t.string   "target"
    t.integer  "status"
    t.text     "elim_location"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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
    t.integer  "kills"
    t.integer  "deaths"
  end

end

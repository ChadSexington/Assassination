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

ActiveRecord::Schema.define(:version => 20131203230605) do

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "irc_nick"
    t.text     "notes"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "current_target"
    t.string   "current_target_status"
    t.text     "dna_times"  # DNA = Do Not Attack (meetings). Should this be a datetime field? What about multiple entries?
  end

  create_table "assignments", :force => true do |t|
    t.integer  "id"
    t.string   "assassin"
    t.string   "target"
    t.integer  "status"    # 0 = in progress, 1 = finished
    t.string   "elim_location"   # might be cool to track trends / see what areas of the floor are most vulnerable
  end

end

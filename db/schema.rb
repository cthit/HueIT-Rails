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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150730101331) do

  create_table "lock_states", force: :cascade do |t|
    t.string   "state",           limit: 255
    t.string   "group",           limit: 255
    t.string   "user",            limit: 255
    t.datetime "expiration_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.string   "cid",        limit: 255
    t.string   "change",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string   "cid",        limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "nick",       limit: 255
    t.string   "mail",       limit: 255
    t.string   "groups",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

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

ActiveRecord::Schema.define(version: 20141229123702) do

  create_table "message_formats", force: true do |t|
    t.string   "name"
    t.string   "regex"
    t.string   "action"
    t.string   "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     default: 0
  end

  create_table "messages", force: true do |t|
    t.string   "source_text"
    t.string   "source_type"
    t.string   "source"
    t.string   "action"
    t.integer  "status"
    t.integer  "message_format_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parameters"
  end

  create_table "patterns", force: true do |t|
    t.string   "name"
    t.integer  "step_size"
    t.integer  "step_count"
    t.string   "instrument_name"
    t.binary   "bits",            limit: 16777215
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "muted",                            default: false
  end

  create_table "samples", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_settings", force: true do |t|
    t.string   "name"
    t.string   "tip"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

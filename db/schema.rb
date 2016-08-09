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

ActiveRecord::Schema.define(version: 20160808211237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "text"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sentiment1"
    t.string   "sentiment2"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "fb_id"
    t.integer  "likes"
    t.integer  "shares"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "pos_sentiment1"
    t.integer  "neg_sentiment1"
    t.integer  "ntr_sentiment1"
    t.integer  "pos_sentiment2"
    t.integer  "neg_sentiment2"
    t.integer  "ntr_sentiment2"
    t.string   "dob"
  end

  add_foreign_key "comments", "posts"
end

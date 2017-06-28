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
#
# I made a change

ActiveRecord::Schema.define(version: 20170627190035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "parties", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "party_songs", force: :cascade do |t|
    t.integer "party_id"
    t.integer "song_id"
    t.integer "votes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "party_users", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id", "user_id"], name: "index_party_users_on_party_id_and_user_id", unique: true
    t.index ["party_id"], name: "index_party_users_on_party_id"
    t.index ["user_id"], name: "index_party_users_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "artist"
    t.string "spotifyID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fb_id", limit: 50, null: false
    t.string "name", limit: 50, null: false
    t.index ["fb_id"], name: "users_fb_id_key", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "party_song_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_song_id"], name: "index_votes_on_party_song_id"
    t.index ["user_id", "party_song_id"], name: "index_votes_on_user_id_and_party_song_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "party_users", "parties"
  add_foreign_key "party_users", "users"
  add_foreign_key "votes", "party_songs"
  add_foreign_key "votes", "users"
end

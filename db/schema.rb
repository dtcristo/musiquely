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

ActiveRecord::Schema.define(version: 20150419111329) do

  create_table "entries", force: :cascade do |t|
    t.integer  "playlist_id", null: false
    t.integer  "track_id",    null: false
    t.integer  "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "entries", ["playlist_id", "position"], name: "index_entries_on_playlist_id_and_position", unique: true
  add_index "entries", ["playlist_id"], name: "index_entries_on_playlist_id"
  add_index "entries", ["track_id"], name: "index_entries_on_track_id"

  create_table "playlists", force: :cascade do |t|
    t.string   "spotify_id",  null: false
    t.string   "snapshot_id"
    t.string   "name"
    t.string   "owner_id",    null: false
    t.datetime "loaded_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists", ["spotify_id"], name: "index_playlists_on_spotify_id", unique: true

  create_table "tracks", force: :cascade do |t|
    t.string   "spotify_id",  null: false
    t.string   "name"
    t.string   "artist"
    t.string   "preview_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tracks", ["spotify_id"], name: "index_tracks_on_spotify_id", unique: true

  create_table "user_playlists", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "playlist_id", null: false
    t.integer  "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_playlists", ["playlist_id"], name: "index_user_playlists_on_playlist_id"
  add_index "user_playlists", ["user_id", "playlist_id"], name: "index_user_playlists_on_user_id_and_playlist_id", unique: true
  add_index "user_playlists", ["user_id", "position"], name: "index_user_playlists_on_user_id_and_position", unique: true
  add_index "user_playlists", ["user_id"], name: "index_user_playlists_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "spotify_id",   null: false
    t.text     "spotify_auth", null: false
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "users", ["spotify_id"], name: "index_users_on_spotify_id", unique: true

end

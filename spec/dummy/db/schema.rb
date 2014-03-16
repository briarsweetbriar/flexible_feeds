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

ActiveRecord::Schema.define(version: 20140227195140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flexible_feeds_event_joins", force: true do |t|
    t.integer  "feed_id"
    t.integer  "event_id"
    t.boolean  "sticky",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_event_joins", ["event_id"], name: "index_flexible_feeds_event_joins_on_event_id", using: :btree
  add_index "flexible_feeds_event_joins", ["feed_id"], name: "index_flexible_feeds_event_joins_on_feed_id", using: :btree
  add_index "flexible_feeds_event_joins", ["sticky"], name: "index_flexible_feeds_event_joins_on_sticky", using: :btree

  create_table "flexible_feeds_events", force: true do |t|
    t.string   "eventable_type"
    t.integer  "eventable_id"
    t.integer  "creator_id"
    t.string   "creator_type"
    t.integer  "parent_id"
    t.integer  "ancestor_id"
    t.integer  "children_count", default: 0,   null: false
    t.integer  "votes_sum",      default: 0,   null: false
    t.integer  "votes_for",      default: 0,   null: false
    t.integer  "votes_against",  default: 0,   null: false
    t.float    "controversy",    default: 0.0, null: false
    t.float    "popularity",     default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_events", ["ancestor_id"], name: "index_flexible_feeds_events_on_ancestor_id", using: :btree
  add_index "flexible_feeds_events", ["children_count"], name: "index_flexible_feeds_events_on_children_count", using: :btree
  add_index "flexible_feeds_events", ["controversy"], name: "index_flexible_feeds_events_on_controversy", using: :btree
  add_index "flexible_feeds_events", ["creator_id", "creator_type"], name: "flexible_feeds_events_on_creator", using: :btree
  add_index "flexible_feeds_events", ["eventable_id", "eventable_type"], name: "flexible_feeds_events_on_eventable", using: :btree
  add_index "flexible_feeds_events", ["parent_id"], name: "index_flexible_feeds_events_on_parent_id", using: :btree
  add_index "flexible_feeds_events", ["popularity"], name: "index_flexible_feeds_events_on_popularity", using: :btree
  add_index "flexible_feeds_events", ["votes_against"], name: "index_flexible_feeds_events_on_votes_against", using: :btree
  add_index "flexible_feeds_events", ["votes_for"], name: "index_flexible_feeds_events_on_votes_for", using: :btree
  add_index "flexible_feeds_events", ["votes_sum"], name: "index_flexible_feeds_events_on_votes_sum", using: :btree

  create_table "flexible_feeds_feeds", force: true do |t|
    t.string   "feedable_type"
    t.integer  "feedable_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_feeds", ["feedable_id", "feedable_type"], name: "flexible_feeds_feeds_on_parent", using: :btree
  add_index "flexible_feeds_feeds", ["name"], name: "index_flexible_feeds_feeds_on_name", using: :btree

  create_table "flexible_feeds_follows", force: true do |t|
    t.integer  "feed_id"
    t.integer  "follower_id"
    t.string   "follower_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_follows", ["feed_id"], name: "index_flexible_feeds_follows_on_feed_id", using: :btree
  add_index "flexible_feeds_follows", ["follower_id", "follower_type"], name: "flexible_feeds_follows_on_follower", using: :btree

  create_table "flexible_feeds_moderator_joins", force: true do |t|
    t.integer  "feed_id"
    t.integer  "moderator_id"
    t.string   "moderator_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_moderator_joins", ["feed_id"], name: "index_flexible_feeds_moderator_joins_on_feed_id", using: :btree
  add_index "flexible_feeds_moderator_joins", ["moderator_id", "moderator_type"], name: "flexible_feeds_moderator_joins_on_moderator", using: :btree

  create_table "flexible_feeds_votes", force: true do |t|
    t.integer  "event_id"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.integer  "value",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flexible_feeds_votes", ["event_id"], name: "index_flexible_feeds_votes_on_event_id", using: :btree
  add_index "flexible_feeds_votes", ["voter_id", "voter_type"], name: "flexible_feeds_votes_on_voter", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permitting_posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unpermitting_posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

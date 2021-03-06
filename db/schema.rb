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

ActiveRecord::Schema.define(version: 20140329011258) do

  create_table "eavesdrops", force: true do |t|
    t.integer  "user_id"
    t.integer  "initiator_id"
    t.integer  "responder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", force: true do |t|
    t.text     "content",    limit: 15000
    t.integer  "user_id"
    t.integer  "initiator"
    t.integer  "responder"
    t.text     "topic",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category"
  end

  create_table "pins", force: true do |t|
    t.text     "description",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "message1"
    t.string   "message2"
    t.string   "message3"
    t.string   "message4"
    t.string   "message5"
    t.string   "message6"
    t.integer  "initiator_id"
    t.integer  "responder_id"
    t.integer  "recommend"
    t.integer  "category"
  end

  add_index "pins", ["user_id"], name: "index_pins_on_user_id"

  create_table "relationships", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "responder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["initiator_id", "responder_id"], name: "index_relationships_on_initiator_id_and_responder_id", unique: true
  add_index "relationships", ["initiator_id"], name: "index_relationships_on_initiator_id"
  add_index "relationships", ["responder_id"], name: "index_relationships_on_responder_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "description"
    t.string   "location"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "featured"
    t.integer  "category"
    t.string   "follow"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

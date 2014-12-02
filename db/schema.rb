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

ActiveRecord::Schema.define(version: 20141104191830) do

  create_table "chats", force: true do |t|
    t.integer  "player_id"
    t.string   "username"
    t.text     "player_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drops", force: true do |t|
    t.string   "name"
    t.integer  "health"
    t.integer  "strength"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.text     "item",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "count"
    t.integer  "health"
    t.integer  "strength"
    t.integer  "experience"
    t.integer  "level"
    t.integer  "hp"
    t.integer  "money"
    t.integer  "min_dmg"
    t.integer  "max_dmg"
    t.integer  "speed"
    t.integer  "agility"
    t.integer  "defence"
    t.integer  "critical"
    t.integer  "critical_multiplier"
    t.string   "itemname"
    t.integer  "grade"
    t.integer  "price"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.integer  "health"
    t.integer  "strength"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monsters", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "health"
    t.integer  "strength"
    t.integer  "experience"
    t.integer  "attacker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "money"
    t.integer  "min_dmg"
    t.integer  "max_dmg"
    t.integer  "speed"
    t.integer  "agility"
    t.integer  "defence"
    t.integer  "critical"
    t.integer  "critical_multiplier"
    t.integer  "evasion"
    t.integer  "accuracy"
    t.integer  "rang"
    t.integer  "Ypos"
    t.integer  "Xpos"
    t.integer  "YposDest"
    t.integer  "XposDest"
    t.boolean  "under_attack"
    t.integer  "max_hp"
  end

  create_table "shops", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "count"
    t.integer  "health"
    t.integer  "strength"
    t.integer  "experience"
    t.integer  "level"
    t.integer  "hp"
    t.integer  "money"
    t.integer  "min_dmg"
    t.integer  "max_dmg"
    t.integer  "speed"
    t.integer  "agility"
    t.integer  "defence"
    t.integer  "critical"
    t.integer  "critical_multiplier"
    t.string   "itemname"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.string   "username"
  end

  create_table "stats", force: true do |t|
    t.integer  "stat"
    t.integer  "health"
    t.integer  "strength"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "experience"
    t.integer  "level"
    t.integer  "player_hp"
    t.integer  "max_hp"
    t.boolean  "attack_allow"
    t.integer  "money"
    t.string   "username"
    t.integer  "min_dmg"
    t.integer  "max_dmg"
    t.integer  "speed"
    t.integer  "agility"
    t.integer  "defence"
    t.integer  "critical"
    t.integer  "critical_multiplier"
    t.integer  "evasion"
    t.integer  "accuracy"
    t.integer  "exp_left"
    t.integer  "medicine1"
    t.integer  "medicine2"
    t.integer  "medicine3"
    t.integer  "medicine4"
    t.integer  "medicine5"
    t.integer  "medicine6"
    t.integer  "medicine7"
    t.integer  "medicine8"
    t.integer  "medicine9"
    t.integer  "medicine10"
    t.integer  "medicine_time"
    t.text     "weapon_name"
    t.integer  "weapon_user_id"
    t.integer  "weapon_strength"
    t.integer  "weapon_health"
    t.integer  "weapon_agility"
    t.integer  "weapon_level"
    t.integer  "weapon_defence"
    t.text     "armor_name"
    t.integer  "armor_user_id"
    t.integer  "armor_strength"
    t.integer  "armor_health"
    t.integer  "armor_agility"
    t.integer  "armor_level"
    t.integer  "armor_defence"
    t.string   "weapon_itemname"
    t.string   "armor_itemname"
    t.string   "gloves_itemname"
    t.string   "shoes_itemname"
    t.string   "helmet_itemname"
    t.text     "gloves_name"
    t.integer  "gloves_user_id"
    t.integer  "gloves_strength"
    t.integer  "gloves_health"
    t.integer  "gloves_agility"
    t.integer  "gloves_level"
    t.integer  "gloves_defence"
    t.text     "shoes_name"
    t.integer  "shoes_user_id"
    t.integer  "shoes_strength"
    t.integer  "shoes_health"
    t.integer  "shoes_agility"
    t.integer  "shoes_level"
    t.integer  "shoes_defence"
    t.text     "helmet_name"
    t.integer  "helmet_user_id"
    t.integer  "helmet_strength"
    t.integer  "helmet_health"
    t.integer  "helmet_agility"
    t.integer  "helmet_level"
    t.integer  "helmet_defence"
    t.integer  "weapon_money"
    t.integer  "armor_money"
    t.integer  "gloves_money"
    t.integer  "shoes_money"
    t.integer  "helmet_money"
    t.integer  "total_health"
    t.integer  "total_strength"
    t.integer  "total_agility"
    t.integer  "total_defence"
    t.integer  "weapon_grade"
    t.integer  "armor_grade"
    t.integer  "gloves_grade"
    t.integer  "shoes_grade"
    t.integer  "helmet_grade"
    t.integer  "mobs_killed"
    t.integer  "monster_hp"
    t.integer  "monster_max_hp"
  end

  add_index "stats", ["user_id"], name: "index_stats_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end

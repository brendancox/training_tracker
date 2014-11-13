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

ActiveRecord::Schema.define(version: 20141113050004) do

  create_table "component_sets", force: true do |t|
    t.integer  "workout_id"
    t.integer  "reps"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workout_component_id"
    t.integer  "num_of_sets"
    t.integer  "rest"
    t.string   "stage"
    t.integer  "template_id"
    t.string   "intensity_plan"
    t.integer  "order"
    t.float    "kg"
  end

  create_table "component_times", force: true do |t|
    t.integer  "workout_id"
    t.integer  "meters"
    t.integer  "seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workout_component_id"
    t.integer  "rest"
    t.string   "stage"
    t.integer  "template_id"
    t.string   "intensity_plan"
    t.integer  "order"
  end

  create_table "templates", force: true do |t|
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "user_id"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "workout_components", force: true do |t|
    t.string   "name"
    t.string   "component_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "equipment"
    t.integer  "user_id"
  end

  create_table "workouts", force: true do |t|
    t.string   "name"
    t.date     "workout_date"
    t.string   "workout_time"
    t.text     "notes"
    t.integer  "template_id"
    t.boolean  "completed",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_18_124900) do
  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "group_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index [ "group_id" ], name: "index_memberships_on_group_id"
    t.index [ "user_id" ], name: "index_memberships_on_user_id"
  end

  create_table "operations", force: :cascade do |t|
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "date"
    t.integer "group_id", null: false
    t.string "name"
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index [ "author_id" ], name: "index_operations_on_author_id"
    t.index [ "group_id" ], name: "index_operations_on_group_id"
  end

  create_table "participations", force: :cascade do |t|
    t.decimal "amount_share", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.integer "operation_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index [ "operation_id" ], name: "index_participations_on_operation_id"
    t.index [ "user_id" ], name: "index_participations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index [ "user_id" ], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index [ "email_address" ], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "operations", "groups"
  add_foreign_key "operations", "users", column: "author_id"
  add_foreign_key "participations", "operations"
  add_foreign_key "participations", "users"
  add_foreign_key "sessions", "users"
end

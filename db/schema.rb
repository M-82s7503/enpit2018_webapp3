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

ActiveRecord::Schema.define(version: 2018_12_01_052026) do

  create_table "achieve_trophies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "trophy_id"
    t.date "achieve_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "index_achieve_trophies_on_project_id"
    t.index ["trophy_id"], name: "index_achieve_trophies_on_trophy_id"
  end

  create_table "github_commit_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "project_id"
    t.string "commit_id"
    t.string "message"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stats_total"
    t.integer "stats_add"
    t.integer "stats_del"
    t.index ["project_id"], name: "index_github_commit_logs_on_project_id"
    t.index ["users_id"], name: "index_github_commit_logs_on_users_id"
  end

  create_table "mail_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "mail_type", null: false
    t.string "img_path"
    t.string "sentence"
    t.integer "contents_id", default: -9
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "users_id"
    t.string "name"
    t.string "owner"
    t.integer "commit_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "goat_eat_speed", default: 1, null: false
    t.integer "day_interval", default: 4, null: false
    t.integer "day_counter", default: 0, null: false
    t.string "newest_commit_id"
    t.bigint "achieve_trophy_id"
    t.index ["achieve_trophy_id"], name: "index_projects_on_achieve_trophy_id"
    t.index ["users_id"], name: "index_projects_on_users_id"
  end

  create_table "trophies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "sentence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img_path", default: "TrophyYagis/futu_yagi.png", null: false
    t.bigint "achieve_trophies_id"
    t.index ["achieve_trophies_id"], name: "index_trophies_on_achieve_trophies_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "github_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "username", default: "anonymous"
    t.string "display_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "achieve_trophies", "projects"
  add_foreign_key "achieve_trophies", "trophies"
  add_foreign_key "github_commit_logs", "projects"
  add_foreign_key "github_commit_logs", "users", column: "users_id"
  add_foreign_key "projects", "achieve_trophies"
  add_foreign_key "projects", "users", column: "users_id"
  add_foreign_key "trophies", "achieve_trophies", column: "achieve_trophies_id"
end

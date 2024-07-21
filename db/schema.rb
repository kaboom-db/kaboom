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

ActiveRecord::Schema[7.1].define(version: 2024_07_21_101933) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collected_issues", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "issue_id", null: false
    t.date "collected_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price_paid", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["issue_id"], name: "index_collected_issues_on_issue_id"
    t.index ["user_id", "issue_id"], name: "index_collected_issues_on_user_id_and_issue_id", unique: true
    t.index ["user_id"], name: "index_collected_issues_on_user_id"
  end

  create_table "comics", force: :cascade do |t|
    t.text "aliases"
    t.string "api_detail_url"
    t.integer "count_of_issues"
    t.datetime "date_last_updated"
    t.text "deck"
    t.text "description"
    t.integer "cv_id", null: false
    t.string "image"
    t.string "name", null: false
    t.string "publisher"
    t.string "site_detail_url"
    t.integer "start_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "nsfw", default: false
    t.string "comic_type"
    t.bigint "country_id"
    t.index ["country_id"], name: "index_comics_on_country_id"
  end

  create_table "comics_genres", id: false, force: :cascade do |t|
    t.bigint "comic_id", null: false
    t.bigint "genre_id", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "language_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "symbol", null: false
    t.string "symbol_native", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.integer "decimal_digits"
    t.integer "rounding"
    t.string "name_plural"
    t.string "placement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourite_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "favouritable_type"
    t.bigint "favouritable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favourite_items_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "target_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["target_id"], name: "index_follows_on_target_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fa_icon", default: "fa-masks-theater", null: false
  end

  create_table "hidden_comics", force: :cascade do |t|
    t.bigint "comic_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comic_id"], name: "index_hidden_comics_on_comic_id"
    t.index ["user_id", "comic_id"], name: "index_hidden_comics_on_unique_combination", unique: true
    t.index ["user_id"], name: "index_hidden_comics_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.text "aliases"
    t.string "api_detail_url"
    t.date "cover_date"
    t.datetime "date_last_updated"
    t.text "deck"
    t.text "description"
    t.integer "cv_id", null: false
    t.string "image"
    t.string "issue_number"
    t.string "name"
    t.string "site_detail_url"
    t.date "store_date"
    t.bigint "comic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rating"
    t.integer "page_count"
    t.string "isbn"
    t.string "upc"
    t.integer "absolute_number"
    t.index ["comic_id"], name: "index_issues_on_comic_id"
    t.index ["issue_number", "comic_id"], name: "index_issues_on_issue_number_and_comic_id", unique: true
  end

  create_table "read_issues", force: :cascade do |t|
    t.datetime "read_at", null: false
    t.bigint "user_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_read_issues_on_issue_id"
    t.index ["user_id"], name: "index_read_issues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "username", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false
    t.boolean "show_nsfw", default: false, null: false
    t.boolean "allow_email_notifications", default: true, null: false
    t.bigint "currency_id"
    t.index ["currency_id"], name: "index_users_on_currency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visit_buckets", force: :cascade do |t|
    t.string "period", null: false
    t.integer "period_start", null: false
    t.integer "period_end", null: false
    t.bigint "user_id"
    t.string "visited_type", null: false
    t.bigint "visited_id", null: false
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "visited_type", "visited_id", "period", "period_start", "period_end"], name: "index_visit_buckets_on_unique_combination", unique: true
    t.index ["user_id"], name: "index_visit_buckets_on_user_id"
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "user_id"
    t.string "visited_type", null: false
    t.bigint "visited_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "wishlistable_type"
    t.bigint "wishlistable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishlist_items_on_user_id"
  end

  add_foreign_key "collected_issues", "issues"
  add_foreign_key "collected_issues", "users"
  add_foreign_key "comics", "countries"
  add_foreign_key "favourite_items", "users"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "follows", "users", column: "target_id"
  add_foreign_key "hidden_comics", "comics"
  add_foreign_key "hidden_comics", "users"
  add_foreign_key "issues", "comics"
  add_foreign_key "read_issues", "issues"
  add_foreign_key "read_issues", "users"
  add_foreign_key "users", "currencies"
  add_foreign_key "visit_buckets", "users"
  add_foreign_key "visits", "users"
  add_foreign_key "wishlist_items", "users"
end

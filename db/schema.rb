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

ActiveRecord::Schema[7.0].define(version: 2023_10_14_143946) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cultivar_groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id", null: false
  end

  create_table "cultivars", force: :cascade do |t|
    t.string "name", null: false
    t.string "breeder"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.boolean "is_deleted", default: false, null: false
    t.integer "bred_year"
    t.integer "introduced_year"
    t.integer "cultivar_group_id", null: false
    t.text "image_url", default: ""
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "favoriter_id"
    t.integer "favorite_cultivar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favorite_cultivar_id"], name: "index_favorites_on_favorite_cultivar_id"
    t.index ["favoriter_id", "favorite_cultivar_id"], name: "index_favorites_on_favoriter_id_and_favorite_cultivar_id", unique: true
    t.index ["favoriter_id"], name: "index_favorites_on_favoriter_id"
  end

  create_table "plants", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "form", default: 0, null: false
    t.bigint "cultivar_id", null: false
    t.bigint "sector_id", null: false
    t.index ["cultivar_id"], name: "index_plants_on_cultivar_id"
    t.index ["sector_id"], name: "index_plants_on_sector_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "coordinates", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geojson_string"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "login_token_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token_digest"
  end

  add_foreign_key "plants", "cultivars"
  add_foreign_key "plants", "sectors"
end

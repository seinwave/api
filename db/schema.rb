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

ActiveRecord::Schema[7.0].define(version: 2023_07_27_171835) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cultivar_colors", force: :cascade do |t|
    t.bigint "cultivar_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approximate_color", default: 0, null: false
    t.string "hsl_value"
    t.index ["cultivar_id"], name: "index_cultivar_colors_on_cultivar_id"
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

  create_table "plant_failures", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plant_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plant_id", null: false
    t.integer "status", default: 0, null: false
    t.index ["plant_id"], name: "index_plant_statuses_on_plant_id"
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

  add_foreign_key "cultivar_colors", "cultivars"
  add_foreign_key "plant_statuses", "plants"
  add_foreign_key "plants", "cultivars"
  add_foreign_key "plants", "sectors"
end

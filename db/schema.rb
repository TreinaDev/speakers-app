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

ActiveRecord::Schema[8.0].define(version: 2025_02_02_203346) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "curriculum_contents", force: :cascade do |t|
    t.integer "curriculum_id", null: false
    t.integer "event_content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_contents_on_curriculum_id"
    t.index ["event_content_id"], name: "index_curriculum_contents_on_event_content_id"
  end

  create_table "curriculum_task_contents", force: :cascade do |t|
    t.integer "curriculum_task_id", null: false
    t.integer "curriculum_content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_content_id"], name: "index_curriculum_task_contents_on_curriculum_content_id"
    t.index ["curriculum_task_id"], name: "index_curriculum_task_contents_on_curriculum_task_id"
  end

  create_table "curriculum_tasks", force: :cascade do |t|
    t.integer "curriculum_id", null: false
    t.string "title"
    t.text "description"
    t.integer "certificate_requirement", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculum_id"], name: "index_curriculum_tasks_on_curriculum_id"
  end

  create_table "curriculums", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "schedule_item_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_curriculums_on_user_id"
  end

  create_table "event_contents", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "external_video_url"
    t.index ["user_id"], name: "index_event_contents_on_user_id"
  end

  create_table "event_task_contents", force: :cascade do |t|
    t.integer "event_content_id", null: false
    t.integer "event_task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_content_id"], name: "index_event_task_contents_on_event_content_id"
    t.index ["event_task_id"], name: "index_event_task_contents_on_event_task_id"
  end

  create_table "event_tasks", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "certificate_requirement", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_event_tasks_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "title"
    t.text "about_me"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "pronoun"
    t.string "gender"
    t.string "city"
    t.date "birth"
    t.boolean "display_gender", default: true
    t.boolean "display_pronoun", default: true
    t.boolean "display_city", default: true
    t.boolean "display_birth", default: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["username"], name: "index_profiles_on_username", unique: true
  end

  create_table "social_networks", force: :cascade do |t|
    t.string "url"
    t.integer "social_network_type"
    t.integer "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_social_networks_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "curriculum_contents", "curriculums"
  add_foreign_key "curriculum_contents", "event_contents"
  add_foreign_key "curriculum_task_contents", "curriculum_contents"
  add_foreign_key "curriculum_task_contents", "curriculum_tasks"
  add_foreign_key "curriculum_tasks", "curriculums"
  add_foreign_key "curriculums", "users"
  add_foreign_key "event_contents", "users"
  add_foreign_key "event_task_contents", "event_contents"
  add_foreign_key "event_task_contents", "event_tasks"
  add_foreign_key "event_tasks", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "social_networks", "profiles"
end

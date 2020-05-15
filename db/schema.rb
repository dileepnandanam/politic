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

ActiveRecord::Schema.define(version: 2020_05_15_035745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "affiliations", force: :cascade do |t|
    t.string "name"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer "response_id"
    t.integer "question_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_response_id"
    t.integer "option_id"
    t.string "line"
    t.integer "group_response_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "reciver_id"
    t.text "text"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "choices", force: :cascade do |t|
    t.integer "option_id"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "connections", force: :cascade do |t|
    t.integer "user_id"
    t.integer "to_user_id"
    t.integer "last_seen_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "galeries", force: :cascade do |t|
    t.integer "post_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "description"
    t.integer "column", default: 1
  end

  create_table "group_responses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.boolean "visible", default: false
    t.boolean "allow_immediate_access", default: true
    t.string "banner_title", default: ""
    t.text "banner_description", default: ""
    t.boolean "bypass_welcome_page", default: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.integer "comment_id"
    t.text "message"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action"
    t.string "target_type"
    t.integer "target_id"
  end

  create_table "options", force: :cascade do |t|
    t.integer "question_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "answer_id"
    t.integer "sequence", default: 0
  end

  create_table "phones", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.integer "galery_id"
    t.integer "post_id"
    t.integer "site_id"
    t.text "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "survey_id"
    t.integer "linked_post_id"
    t.string "linked_post_name"
    t.text "alt_text"
  end

  create_table "posts", force: :cascade do |t|
    t.text "text"
    t.integer "user_id"
    t.integer "post_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "title"
    t.boolean "hidden"
    t.integer "survey_id"
    t.boolean "featured", default: false
    t.integer "quick_poll_id"
    t.integer "project_id"
    t.text "survey_tags", default: ""
    t.boolean "free"
    t.float "lat"
    t.float "lngt"
    t.text "site_tags", default: ""
    t.boolean "enable_comment_vote", default: false
    t.integer "sequence", default: 0
    t.text "galery_tags", default: ""
    t.text "picture_tags", default: ""
    t.boolean "visible", default: true
    t.text "tag_set", default: ""
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "pinterest_url"
    t.string "gmail"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "user_id"
    t.text "text"
    t.integer "sequence", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "survey_id"
    t.integer "quick_poll_id"
    t.string "answer_type", default: "text"
  end

  create_table "quick_poll_responses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "quick_poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
  end

  create_table "quick_polls", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "responce_user_id"
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_responses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "new"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.boolean "anonymous", default: false
    t.string "button_name", default: "submit"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "image"
    t.string "gender"
    t.string "link"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.text "badwords"
    t.string "pin"
    t.boolean "admin", default: false
    t.string "usertype"
    t.float "lat"
    t.float "lngt"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "v2_notifications", force: :cascade do |t|
    t.integer "target_id"
    t.integer "sender_id"
    t.string "item_type"
    t.integer "item_id"
    t.string "action"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer "post_id"
    t.integer "group_id"
    t.string "request_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end

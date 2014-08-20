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

ActiveRecord::Schema.define(version: 20140819225631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "blacklists", force: true do |t|
    t.string   "ip"
    t.integer  "blocked_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.string   "cname"
    t.string   "youtube_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "missionhub_token"
    t.string   "permalink"
    t.string   "video_id"
    t.string   "campaign_type"
    t.string   "uid"
    t.integer  "max_chats"
    t.string   "chat_start"
    t.string   "owner"
    t.integer  "user_id"
    t.text     "description"
    t.string   "language"
    t.string   "password_hash"
    t.integer  "admin1_id"
    t.integer  "admin2_id"
    t.integer  "admin3_id"
    t.boolean  "preemptive_chat"
    t.string   "growth_challenge", default: "operator"
    t.integer  "status",           default: 0,          null: false
  end

  create_table "chats", force: true do |t|
    t.string   "topic"
    t.integer  "operator_id"
    t.integer  "visitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.integer  "campaign_id"
    t.string   "status"
    t.integer  "operator_whose_link_id"
    t.text     "mh_comment"
    t.boolean  "visitor_active",         default: false
    t.integer  "user_messages_count",    default: 0
  end

  add_index "chats", ["operator_id"], name: "index_chats_on_operator_id", using: :btree
  add_index "chats", ["visitor_id"], name: "index_chats_on_visitor_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "outsider_id"
    t.integer  "operator_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["operator_id"], name: "index_comments_on_operator_id", using: :btree
  add_index "comments", ["outsider_id"], name: "index_comments_on_outsider_id", using: :btree

  create_table "create_fe_phone_numbers", force: true do |t|
    t.string   "number"
    t.string   "extensions"
    t.integer  "person_id"
    t.string   "location"
    t.boolean  "primary"
    t.string   "txt_to_email"
    t.integer  "carrier_id"
    t.datetime "email_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "emails", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "from_name"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagement_players", force: true do |t|
    t.boolean  "enabled"
    t.string   "media_link"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_addresses", force: true do |t|
    t.datetime "startdate"
    t.datetime "enddate"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "address_type"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_answer_sheet_question_sheets", force: true do |t|
    t.integer  "answer_sheet_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_answer_sheet_question_sheets", ["answer_sheet_id", "question_sheet_id"], name: "answer_sheet_question_sheet", using: :btree

  create_table "fe_answers", force: true do |t|
    t.integer  "answer_sheet_id",         null: false
    t.integer  "question_id",             null: false
    t.text     "value"
    t.string   "short_value"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_answers", ["answer_sheet_id", "question_id"], name: "answer_sheet_question", using: :btree
  add_index "fe_answers", ["short_value"], name: "index_fe_answers_on_short_value", using: :btree

  create_table "fe_applications", force: true do |t|
    t.integer  "applicant_id"
    t.string   "status"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_applications", ["applicant_id"], name: "question_sheet_id", using: :btree

  create_table "fe_conditions", force: true do |t|
    t.integer  "question_sheet_id", null: false
    t.integer  "trigger_id",        null: false
    t.string   "expression",        null: false
    t.integer  "toggle_page_id",    null: false
    t.integer  "toggle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_conditions", ["question_sheet_id"], name: "index_fe_conditions_on_question_sheet_id", using: :btree
  add_index "fe_conditions", ["toggle_id"], name: "index_fe_conditions_on_toggle_id", using: :btree
  add_index "fe_conditions", ["toggle_page_id"], name: "index_fe_conditions_on_toggle_page_id", using: :btree
  add_index "fe_conditions", ["trigger_id"], name: "index_fe_conditions_on_trigger_id", using: :btree

  create_table "fe_elements", force: true do |t|
    t.integer  "question_grid_id"
    t.string   "kind",                      limit: 40,                 null: false
    t.string   "style",                     limit: 40
    t.string   "label"
    t.text     "content"
    t.boolean  "required"
    t.string   "slug",                      limit: 36
    t.integer  "position"
    t.string   "object_name"
    t.string   "attribute_name"
    t.string   "source"
    t.string   "value_xpath"
    t.string   "text_xpath"
    t.string   "cols"
    t.boolean  "is_confidential",                      default: false
    t.string   "total_cols"
    t.string   "css_id"
    t.string   "css_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "related_question_sheet_id"
    t.integer  "conditional_id"
    t.text     "tooltip"
    t.boolean  "hide_label",                           default: false
    t.boolean  "hide_option_labels",                   default: false
    t.integer  "max_length"
    t.string   "conditional_type"
    t.text     "conditional_answer"
  end

  add_index "fe_elements", ["conditional_id"], name: "index_fe_elements_on_conditional_id", using: :btree
  add_index "fe_elements", ["question_grid_id"], name: "index_fe_elements_on_question_grid_id", using: :btree
  add_index "fe_elements", ["slug"], name: "index_fe_elements_on_slug", using: :btree

  create_table "fe_email_templates", force: true do |t|
    t.string   "name",       limit: 1000, null: false
    t.text     "content"
    t.boolean  "enabled"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_page_elements", force: true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_page_elements", ["page_id", "element_id"], name: "page_element", using: :btree

  create_table "fe_pages", force: true do |t|
    t.integer  "question_sheet_id",                            null: false
    t.string   "label",             limit: 60,                 null: false
    t.integer  "number"
    t.boolean  "no_cache",                     default: false
    t.boolean  "hidden",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.boolean  "is_staff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_question_sheets", force: true do |t|
    t.string   "label",      limit: 100,                 null: false
    t.boolean  "archived",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fe_references", force: true do |t|
    t.integer  "question_id"
    t.integer  "applicant_answer_sheet_id"
    t.datetime "email_sent_at"
    t.string   "relationship"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "status"
    t.datetime "submitted_at"
    t.string   "access_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fe_references", ["applicant_answer_sheet_id"], name: "index_fe_references_on_applicant_answer_sheet_id", using: :btree
  add_index "fe_references", ["question_id"], name: "index_fe_references_on_question_id", using: :btree

  create_table "fe_users", force: true do |t|
    t.integer  "user_id"
    t.datetime "last_login"
    t.string   "type"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followup_buttons", force: true do |t|
    t.string   "btn_text"
    t.string   "btn_action"
    t.string   "btn_value"
    t.integer  "campaign_id"
    t.text     "message_active_chat"
    t.text     "message_no_chat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "btn_id"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entries", force: true do |t|
    t.string   "ip"
    t.string   "host"
    t.string   "controller"
    t.string   "action"
    t.string   "path"
    t.boolean  "blocked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "users_id"
    t.integer  "organizations_id"
    t.boolean  "valid"
    t.boolean  "admin"
    t.boolean  "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["organizations_id"], name: "index_memberships_on_organizations_id", using: :btree
  add_index "memberships", ["users_id"], name: "index_memberships_on_users_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "chat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "message_type"
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "resource_id"
    t.integer  "user_id"
    t.integer  "state",         default: 0, null: false
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "url_fwds", force: true do |t|
    t.string   "short_url"
    t.string   "uid"
    t.string   "full_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_operators", force: true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "url_fwd_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                      default: ""
    t.integer  "sign_in_count",              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "operator_uid"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "status"
    t.string   "location"
    t.string   "ip"
    t.string   "referrer"
    t.string   "authentication_token"
    t.string   "refresh_token"
    t.datetime "token_expires_at"
    t.string   "fb_uid"
    t.string   "channel"
    t.integer  "missionhub_id"
    t.integer  "campaign_id"
    t.string   "locale"
    t.text     "answers"
    t.string   "visitor_uid"
    t.string   "profile_pic"
    t.boolean  "admin",                      default: false
    t.boolean  "operator",                   default: false
    t.boolean  "visitor",                    default: true
    t.boolean  "challenge_subscribe_self"
    t.string   "challenge_subscribe_friend"
    t.integer  "assigned_operator1_id"
    t.integer  "assigned_operator2_id"
    t.string   "challenge_friend_accepted"
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  create_table "users_languages", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
  end

end

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

ActiveRecord::Schema.define(version: 20141023020216) do

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

  create_table "available_locales", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "locale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_communities", force: true do |t|
    t.integer  "campaign_id"
    t.string   "url"
    t.text     "description"
    t.boolean  "other_campaign"
    t.integer  "child_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "enabled",           default: true
  end

  create_table "campaign_engagement_players", force: true do |t|
    t.boolean  "enabled"
    t.string   "media_link"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "media_start"
    t.integer  "media_stop"
  end

  create_table "campaign_shares", force: true do |t|
    t.boolean  "enabled",     default: true
    t.string   "title"
    t.text     "description"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.text     "message"
  end

  create_table "campaign_survey_question_options", force: true do |t|
    t.string   "title"
    t.integer  "conditional",             default: 0
    t.string   "code"
    t.integer  "question_id"
    t.integer  "conditional_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_survey_questions", force: true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.string   "help_text"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "campaign_surveys", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",     default: true
    t.integer  "campaign_id"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "missionhub_token"
    t.integer  "status",           default: 0,    null: false
    t.integer  "locale_id"
    t.boolean  "subdomain",        default: true
  end

  add_index "campaigns", ["locale_id"], name: "index_campaigns_on_locale_id", using: :btree
  add_index "campaigns", ["url"], name: "index_campaigns_on_url", using: :btree

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

  create_table "locales", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "flag"
    t.boolean  "rtl",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer "user_id"
    t.integer "resource_id"
    t.string  "resource_type"
    t.integer "state",         default: 0
    t.integer "locale_id"
  end

  add_index "permissions", ["resource_id"], name: "index_permissions_on_resource_id", using: :btree
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree

  create_table "translations", force: true do |t|
    t.string   "content"
    t.integer  "resource_id"
    t.integer  "campaign_id"
    t.integer  "locale_id"
    t.string   "field"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_type"
    t.boolean  "base",          default: false
  end

  add_index "translations", ["campaign_id"], name: "index_translations_on_campaign_id", using: :btree
  add_index "translations", ["field"], name: "index_translations_on_field", using: :btree
  add_index "translations", ["locale_id"], name: "index_translations_on_locale_id", using: :btree
  add_index "translations", ["resource_id"], name: "index_translations_on_resource_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.integer  "sign_in_count",          default: 0
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
    t.string   "authentication_token"
    t.string   "refresh_token"
    t.datetime "token_expires_at"
    t.string   "fb_uid"
    t.string   "profile_pic"
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "roles_mask"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree

  create_table "visitor_interactions", force: true do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "visitor_id"
    t.integer  "campaign_id"
    t.integer  "action"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visitor_interactions", ["campaign_id"], name: "index_visitor_interactions_on_campaign_id", using: :btree
  add_index "visitor_interactions", ["resource_id"], name: "index_visitor_interactions_on_resource_id", using: :btree
  add_index "visitor_interactions", ["visitor_id"], name: "index_visitor_interactions_on_visitor_id", using: :btree

  create_table "visitor_invitations", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "invitee_id"
    t.integer  "inviter_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visitors", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "authentication_token"
    t.string  "share_token"
    t.string  "encrypted_password"
    t.integer "inviter_id"
    t.boolean "notify_inviter",       default: false
    t.boolean "notify_me_on_share",   default: false
  end

  add_index "visitors", ["authentication_token"], name: "index_visitors_on_authentication_token", unique: true, using: :btree
  add_index "visitors", ["email"], name: "index_visitors_on_email", unique: true, using: :btree
  add_index "visitors", ["inviter_id"], name: "index_visitors_on_inviter_id", using: :btree
  add_index "visitors", ["share_token"], name: "index_visitors_on_share_token", unique: true, using: :btree

end

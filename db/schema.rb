# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081115175614) do

  create_table "act_texts", :force => true do |t|
    t.integer "activity_id"
    t.text    "act_description"
  end

  add_index "act_texts", ["activity_id"], :name => "act_index"

  create_table "activities", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.integer  "place_id"
    t.integer  "backplace_id"
    t.string   "act_subject",   :limit => 200
    t.string   "act_type",      :limit => 12
    t.string   "act_place",     :limit => 200
    t.string   "place_name",    :limit => 100
    t.string   "access_type",   :limit => 12
    t.string   "view_category", :limit => 12
    t.string   "category",      :limit => 50
    t.string   "hot_category",  :limit => 50
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "act_year"
    t.integer  "act_month"
    t.integer  "act_week"
    t.integer  "act_day"
    t.integer  "act_hour"
    t.datetime "updated_on"
    t.integer  "end_year"
    t.integer  "end_month"
    t.integer  "end_day"
    t.integer  "end_week"
    t.integer  "end_hour"
    t.integer  "publish_ind",   :limit => 2
    t.string   "act_location",  :limit => 50
    t.integer  "view_count"
    t.integer  "comment_count"
    t.integer  "rank"
    t.integer  "whole_day",     :limit => 1
    t.integer  "useless_count", :limit => 1
    t.integer  "useful_count",  :limit => 1
    t.integer  "auth",          :limit => 1
    t.string   "attach1",       :limit => 100
    t.string   "pic_link",      :limit => 250
    t.integer  "is_long"
    t.datetime "created_on"
  end

  add_index "activities", ["calendar_id"], :name => "activity_fk1"
  add_index "activities", ["view_count"], :name => "act_index_3"
  add_index "activities", ["updated_on"], :name => "act_index_7"
  add_index "activities", ["start_time", "end_time", "access_type", "category"], :name => "activity_index1"
  add_index "activities", ["user_id", "access_type", "end_time"], :name => "act_index_5"
  add_index "activities", ["user_id", "access_type", "category", "end_time"], :name => "act_index_4"
  add_index "activities", ["access_type", "category", "end_time"], :name => "act_index_2"
  add_index "activities", ["place_id", "place_name"], :name => "new_indexpp"
  add_index "activities", ["act_year", "act_month", "act_day"], :name => "act_index_9"
  add_index "activities", ["access_type", "auth"], :name => "act_index"

  create_table "mail_remindings", :force => true do |t|
    t.integer  "activity_id"
    t.string   "title",       :limit => 200
    t.string   "link",        :limit => 50
    t.string   "start_time",  :limit => 30
    t.string   "end_time",    :limit => 30
    t.datetime "remind_time"
    t.integer  "done",        :limit => 1
    t.string   "mailbox",     :limit => 50
    t.string   "act_subject", :limit => 200
    t.integer  "user_id"
  end

  add_index "mail_remindings", ["activity_id"], :name => "index_mail_remindings_on_activity_id"
  add_index "mail_remindings", ["user_id"], :name => "index_mail_remindings_on_user_id"

  create_table "sns_commits", :force => true do |t|
    t.integer  "sns_user_xid"
    t.integer  "activity_id"
    t.text     "content"
    t.integer  "reply_xid"
    t.boolean  "sented"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sns_commits", ["sns_user_xid"], :name => "index_sns_commits_on_sns_user_xid"
  add_index "sns_commits", ["activity_id"], :name => "index_sns_commits_on_activity_id"
  add_index "sns_commits", ["updated_at"], :name => "index_sns_commits_on_updated_at"

  create_table "sns_my_activities", :force => true do |t|
    t.integer  "sns_user_id"
    t.integer  "activity_id"
    t.boolean  "join"
    t.boolean  "interest"
    t.boolean  "share"
    t.string   "share_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sns_my_activities", ["sns_user_id", "activity_id", "join"], :name => "index_sns_my_activities_on_sns_user_id_and_activity_id_and_join"
  add_index "sns_my_activities", ["activity_id"], :name => "index_sns_my_activities_on_activity_id"

  create_table "sns_users", :force => true do |t|
    t.string   "xid",          :limit => 30, :default => "", :null => false
    t.text     "friend_ids"
    t.string   "session_key"
    t.string   "act_location", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mailbox"
  end

  add_index "sns_users", ["xid"], :name => "index_sns_users_on_xid"
  add_index "sns_users", ["act_location"], :name => "index_sns_users_on_act_location"
  add_index "sns_users", ["updated_at"], :name => "index_sns_users_on_updated_at"

end

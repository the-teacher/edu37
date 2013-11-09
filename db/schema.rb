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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110308065923) do

  create_table "audits", :force => true do |t|
    t.integer  "user_id"
    t.string   "object_type"
    t.integer  "object_id"
    t.string   "object_zip"
    t.string   "controller"
    t.string   "action"
    t.string   "ip"
    t.string   "remote_ip"
    t.string   "request_uri"
    t.string   "referer"
    t.string   "user_agent"
    t.string   "remote_addr"
    t.string   "remote_host"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "zip"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "object_zip"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.text     "css_addons"
    t.text     "js_addons"
    t.string   "title",                                  :null => false
    t.string   "contacts",                               :null => false
    t.text     "textile_content",                        :null => false
    t.text     "html_content",                           :null => false
    t.string   "state",            :default => "unsafe"
    t.string   "moderation_state", :default => "unsafe"
    t.string   "view_token"
    t.float    "positive_value",   :default => 0.0
    t.float    "negative_value",   :default => 0.0
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "forums", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.string   "title",                                         :null => false
    t.text     "description",                                   :null => false
    t.text     "header_addons"
    t.text     "footer_addons"
    t.integer  "last_topic_id"
    t.string   "last_topic_zip"
    t.string   "last_topic_title"
    t.integer  "last_comment_id"
    t.string   "last_comment_zip"
    t.integer  "last_comment_user_id"
    t.string   "last_comment_user_zip"
    t.string   "last_comment_user_login"
    t.integer  "show_count",              :default => 0
    t.integer  "topics_count",            :default => 0
    t.integer  "comments_count",          :default => 0
    t.text     "settings"
    t.string   "state",                   :default => "unsafe"
    t.string   "moderation_state",        :default => "unsafe"
    t.string   "view_token"
    t.float    "positive_value",          :default => 0.0
    t.float    "negative_value",          :default => 0.0
    t.string   "tags_inline"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs", :force => true do |t|
    t.string   "zip"
    t.string   "context"
    t.integer  "sender_id"
    t.string   "sender_role"
    t.integer  "recipient_id"
    t.string   "recipient_role"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "zip"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.text     "css_addons"
    t.text     "js_addons"
    t.string   "title"
    t.string   "contacts"
    t.text     "textile_content"
    t.text     "html_content"
    t.string   "state",            :default => "unsafe"
    t.string   "moderation_state", :default => "unsafe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.string   "author"
    t.string   "keywords"
    t.string   "description"
    t.string   "copyright"
    t.text     "css_addons"
    t.text     "js_addons"
    t.string   "title",                                    :null => false
    t.text     "textile_content",                          :null => false
    t.text     "html_content",                             :null => false
    t.text     "header_addons"
    t.text     "footer_addons"
    t.text     "settings"
    t.string   "state",              :default => "unsafe"
    t.string   "moderation_state",   :default => "unsafe"
    t.string   "view_token"
    t.integer  "comments_count",     :default => 0
    t.integer  "show_count",         :default => 0
    t.float    "positive_value",     :default => 0.0
    t.float    "negative_value",     :default => 0.0
    t.string   "tags_inline"
    t.datetime "first_published_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",              :default => true,     :null => false
  end

  create_table "preregs", :force => true do |t|
    t.string   "zip"
    t.string   "name"
    t.string   "email"
    t.string   "hash_key"
    t.string   "state",      :default => "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "css_addons"
    t.text     "js_addons"
    t.text     "textile_content",                                          :null => false
    t.text     "html_content",                                             :null => false
    t.string   "www",              :limit => 100
    t.string   "icq",              :limit => 100
    t.string   "skype",            :limit => 100
    t.string   "phone",            :limit => 100
    t.string   "address",          :limit => 100
    t.string   "facebook",         :limit => 50
    t.string   "twitter",          :limit => 50
    t.string   "facebook_api_key", :limit => 150
    t.string   "twitter_api_key",  :limit => 150
    t.text     "header_addons"
    t.text     "footer_addons"
    t.text     "settings"
    t.string   "state",                           :default => "published"
    t.string   "moderation_state",                :default => "unsafe"
    t.string   "tags_inline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.string   "author"
    t.string   "keywords"
    t.string   "description"
    t.string   "copyright"
    t.text     "css_annotation_addons"
    t.text     "js_annotation_addons"
    t.text     "css_addons"
    t.text     "js_addons"
    t.string   "title"
    t.text     "textile_annotation",                          :null => false
    t.text     "html_annotation",                             :null => false
    t.text     "textile_content",                             :null => false
    t.text     "html_content",                                :null => false
    t.text     "header_addons"
    t.text     "footer_addons"
    t.text     "settings"
    t.string   "state",                 :default => "unsafe"
    t.string   "moderation_state",      :default => "unsafe"
    t.string   "view_token"
    t.integer  "comments_count",        :default => 0
    t.integer  "show_count",            :default => 0
    t.float    "positive_value",        :default => 0.0
    t.float    "negative_value",        :default => 0.0
    t.string   "tags_inline"
    t.datetime "first_published_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "zip"
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "index_simple_captcha_data_on_key"

  create_table "storages", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.string   "title",                                    :null => false
    t.integer  "files_count",      :default => 0
    t.integer  "files_size",       :default => 0
    t.text     "settings"
    t.string   "state",            :default => "personal"
    t.string   "moderation_state", :default => "unsafe"
    t.integer  "comments_count",   :default => 0
    t.integer  "show_count",       :default => 0
    t.float    "positive_value",   :default => 0.0
    t.float    "negative_value",   :default => 0.0
    t.string   "tags_inline"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "deptht",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "taggings_key"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.text     "css_addons"
    t.text     "js_addons"
    t.string   "title",                                         :null => false
    t.text     "textile_content",                               :null => false
    t.text     "html_content",                                  :null => false
    t.text     "header_addons"
    t.text     "footer_addons"
    t.integer  "forum_id"
    t.string   "forum_zip"
    t.string   "forum_title"
    t.integer  "last_comment_id"
    t.string   "last_comment_zip"
    t.integer  "last_comment_user_id"
    t.string   "last_comment_user_zip"
    t.string   "last_comment_user_login"
    t.text     "settings"
    t.string   "state",                   :default => "draft"
    t.string   "moderation_state",        :default => "unsafe"
    t.string   "view_token"
    t.integer  "show_count",              :default => 0
    t.integer  "comments_count",          :default => 0
    t.float    "positive_value",          :default => 0.0
    t.float    "negative_value",          :default => 0.0
    t.string   "tags_inline"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_files", :force => true do |t|
    t.string   "zip"
    t.string   "friendly_url"
    t.integer  "storage_id"
    t.string   "storage_type"
    t.integer  "user_id"
    t.string   "user_zip"
    t.string   "user_login"
    t.integer  "creator_id"
    t.string   "creator_zip"
    t.string   "creator_login"
    t.string   "title",                                   :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size",    :default => 0
    t.datetime "file_updated_at"
    t.string   "state",             :default => "unsafe"
    t.string   "moderation_state",  :default => "unsafe"
    t.integer  "comments_count",    :default => 0
    t.float    "positive_value",    :default => 0.0
    t.float    "negative_value",    :default => 0.0
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "deptht",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",             :default => true,     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "zip"
    t.string   "title"
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.integer  "sex",                                      :default => 1
    t.integer  "role_id"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "time_zone",                                :default => "Europe/Moscow"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "site_header_file_name"
    t.string   "site_header_content_type"
    t.integer  "site_header_file_size"
    t.datetime "site_header_updated_at"
    t.integer  "files_count",                              :default => 0
    t.integer  "files_size",                               :default => 0
    t.integer  "files_max_volume",                         :default => 0
    t.text     "settings"
    t.string   "state",                                    :default => "published"
    t.string   "moderation_state",                         :default => "unsafe"
    t.integer  "comments_count",                           :default => 0
    t.integer  "show_count",                               :default => 0
    t.float    "positive_value",                           :default => 0.0
    t.float    "negative_value",                           :default => 0.0
    t.string   "tags_inline"
    t.float    "karma",                                    :default => 0.0
    t.float    "raiting",                                  :default => 0.0
    t.float    "power",                                    :default => 0.0
  end

  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["zip"], :name => "index_users_on_zip", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.float    "value"
    t.string   "ip"
    t.string   "remote_ip"
    t.string   "view_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

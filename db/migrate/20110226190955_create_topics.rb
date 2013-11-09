class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string  :zip
      t.string  :friendly_url
      # recipient (owner)
      t.integer :user_id
      t.string  :user_zip
      t.string  :user_login
      # creator
      t.integer :creator_id
      t.string  :creator_zip
      t.string  :creator_login

      # for content
      t.text :css_addons
      t.text :js_addons

      # CONTENT
      t.string :title, :null => false

      t.text :textile_content, :null => false
      t.text :html_content, :null => false

      # addons
      t.text :header_addons
      t.text :footer_addons

      # forum info
      t.integer :forum_id
      t.string  :forum_zip
      t.string  :forum_title

      t.integer :last_comment_id
      t.string  :last_comment_zip

      t.integer :last_comment_user_id
      t.string  :last_comment_user_zip
      t.string  :last_comment_user_login

      # settings
      t.text    :settings
      t.string  :state,             :default=>'draft'
      t.string  :moderation_state,  :default=>'unsafe'
      t.string  :view_token

      # counters
      t.integer :show_count, :default=>0
      t.integer :comments_count, :default=>0
      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0
      # inline elements
      t.string :tags_inline

      # ans
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end

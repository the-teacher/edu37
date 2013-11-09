class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
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

      # CONTENT
      t.string :title, :null => false
      t.text   :description, :null => false

      # addons
      t.text :header_addons
      t.text :footer_addons

      # ADDITIONAL INFO
      t.integer :last_topic_id
      t.string  :last_topic_zip
      t.string  :last_topic_title

      t.integer :last_comment_id
      t.string  :last_comment_zip

      t.integer :last_comment_user_id
      t.string  :last_comment_user_zip
      t.string  :last_comment_user_login

      # counters
      t.integer :show_count, :default=>0
      t.integer :topics_count, :default=>0
      t.integer :comments_count, :default=>0

      # settings
      t.text    :settings
      t.string  :state, :default=>'unsafe'
      t.string  :moderation_state, :default=>'unsafe'
      t.string  :view_token

      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0
      # inline elements
      t.string :tags_inline

      # nested_set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :forums
  end
end

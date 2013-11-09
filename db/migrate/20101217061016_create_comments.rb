class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :zip
      # commentable object
      t.integer :object_id
      t.string  :object_type
      t.string  :object_zip

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
      t.string :contacts, :null => false

      t.text   :textile_content, :null => false
      t.text   :html_content, :null => false

      # settings
      t.string  :state, :default=>'unsafe'
      t.string  :moderation_state, :default=>'unsafe'
      t.string  :view_token

      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0

      # nested_set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

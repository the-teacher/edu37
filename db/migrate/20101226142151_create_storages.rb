class CreateStorages < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
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

      # files info
      t.integer :files_count, :default=>0
      t.integer :files_size, :default=>0

      # settings
      t.text    :settings
      t.string  :state, :default=>'personal'
      t.string  :moderation_state, :default=>'unsafe'

      # comments
      t.integer :comments_count, :default=>0
      # show count
      t.integer :show_count, :default=>0
      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0
      # inline elements
      t.string  :tags_inline

      # ans
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :deptht, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :storages
  end
end

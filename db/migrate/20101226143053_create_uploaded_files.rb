class CreateUploadedFiles < ActiveRecord::Migration
  def self.up
    create_table :uploaded_files do |t|
      t.string  :zip
      t.string  :friendly_url
      # polymorphic
      t.integer :storage_id
      t.string  :storage_type
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

      # paperclip
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size, :default=>0
      t.datetime :file_updated_at

      # settings
      t.string  :state, :default=>'unsafe'
      t.string  :moderation_state, :default=>'unsafe'

      # comments
      t.integer :comments_count, :default=>0
      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0

      # ans
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :deptht, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_files
  end
end

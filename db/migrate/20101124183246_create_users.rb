class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      # basic data
      t.string  :zip                                                    # u27456
      t.string  :title                                                  # Greate site for recipes
      t.string  :login, :limit => 40                                    # alex
      t.string  :name,  :limit => 100, :default => '', :null => true    # Alexandr Khvorov
      t.string  :email, :limit => 100                                   # alex@JosephStalin.com
      t.integer :sex, :default=>1                                       # 1
      t.integer :role_id                                                # 3

      # password
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40

      # info
      t.datetime  :created_at
      t.datetime  :updated_at
      t.datetime  :last_login_at
      t.string    :remember_token, :limit => 40
      t.datetime  :remember_token_expires_at
      t.string    :time_zone, :default => 'Europe/Moscow'

      # avatar
      t.column :avatar_file_name,     :string
      t.column :avatar_content_type,  :string
      t.column :avatar_file_size,     :integer
      t.column :avatar_updated_at,    :datetime
      # header of user section site
      t.column :site_header_file_name,    :string
      t.column :site_header_content_type, :string
      t.column :site_header_file_size,    :integer
      t.column :site_header_updated_at,   :datetime
      # files
      t.integer :files_count, :default=>0
      t.integer :files_size, :default=>0
      t.integer :files_max_volume, :default=>0

      # settings
      t.text    :settings
      t.string  :state, :default=>'published'
      t.string  :moderation_state, :default=>'unsafe'

      # comments
      t.integer :comments_count, :default=>0
      # show count
      t.integer :show_count, :default=>0
      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0
      # inline elements
      t.string :tags_inline

      # act_as_karma (its can be funny)
      t.float :karma,   :default=>0
      t.float :raiting, :default=>0
      t.float :power,   :default=>0
    end
    add_index :users, :id,    :unique => true
    add_index :users, :zip,   :unique => true
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end

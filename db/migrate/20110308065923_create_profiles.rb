class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      # for content
      t.text :css_addons
      t.text :js_addons

      # CONTENT
      t.text    :textile_content, :null => false
      t.text    :html_content, :null => false

      # messangers
      t.string  :www,     :limit => 100
      t.string  :icq,     :limit => 100
      t.string  :skype,   :limit => 100
      t.string  :phone,   :limit => 100
      t.string  :address, :limit => 100
      # Social network fields
      t.string  :facebook,      :limit => 50
      t.string  :twitter,       :limit => 50
      # Social network API keys
      t.string  :facebook_api_key,       :limit => 150
      t.string  :twitter_api_key,        :limit => 150

      # addons
      t.text :header_addons
      t.text :footer_addons

      # settings
      t.text    :settings
      t.string  :state, :default=>'published'
      t.string  :moderation_state, :default=>'unsafe'

      # inline elements
      t.string  :tags_inline

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end

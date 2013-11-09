class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :zip
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
      t.string  :title
      t.string  :contacts

      t.text    :textile_content
      t.text    :html_content

      # settings
      t.string  :state,             :default=>'unsafe'
      t.string  :moderation_state,  :default=>'unsafe'

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end

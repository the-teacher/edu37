class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.string :zip
      t.string :friendly_url
      # recipient (owner)
      t.integer :user_id
      t.string  :user_zip
      t.string  :user_login
      # creator
      t.integer :creator_id
      t.string  :creator_zip
      t.string  :creator_login
      # meta
      t.string :author
      t.string :keywords
      t.string :description
      t.string :copyright
      # for annotation
      t.text :css_annotation_addons
      t.text :js_annotation_addons
      # for content
      t.text :css_addons
      t.text :js_addons

      # CONTENT
      t.string :title

      t.text :textile_annotation, :null => false
      t.text :html_annotation, :null => false

      t.text :textile_content, :null => false
      t.text :html_content, :null => false

      # addons
      t.text :header_addons
      t.text :footer_addons

      # settings
      t.text    :settings
      t.string  :state, :default=>'unsafe'
      t.string  :moderation_state, :default=>'unsafe'
      t.string  :view_token

      # comments
      t.integer :comments_count, :default=>0
      # show count
      t.integer :show_count, :default=>0
      # votes
      t.float :positive_value, :default=>0
      t.float :negative_value, :default=>0
      # inline elements
      t.string    :tags_inline
      t.datetime  :first_published_at

      # nested_set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :publications
  end
end

class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|

      t.string :zip
      t.string :name
      t.string :title
      t.text :description
      t.text :settings

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end

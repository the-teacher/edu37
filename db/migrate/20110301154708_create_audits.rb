class CreateAudits < ActiveRecord::Migration
  def self.connection  
    Audit.connection
  end

  def self.up
    create_table :audits do |t|
      t.integer :user_id

      t.string  :object_type
      t.integer :object_id
      t.string  :object_zip

      t.string :controller
      t.string :action

      t.string :ip
      t.string :remote_ip
      t.string :request_uri
      t.string :referer
      t.string :user_agent
      t.string :remote_addr
      t.string :remote_host

      t.timestamps
    end
  end

  def self.down
    drop_table :audits
  end
end

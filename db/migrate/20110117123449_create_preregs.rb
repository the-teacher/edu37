class CreatePreregs < ActiveRecord::Migration
  def self.up
    create_table :preregs do |t|
      t.string :zip
      t.string :name     
      t.string :email
      t.string :hash_key
      t.string :state, :default=>:pending

      t.timestamps
    end
  end

  def self.down
    drop_table :preregs
  end
end

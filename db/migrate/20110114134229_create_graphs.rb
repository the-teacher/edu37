class CreateGraphs < ActiveRecord::Migration
  def self.up
    create_table :graphs do |t|
      t.string :zip
      t.string :context

      t.integer :sender_id
      t.string :sender_role

      t.integer :recipient_id
      t.string :recipient_role
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :graphs
  end
end

class AddSphinxDelta < ActiveRecord::Migration
  def self.up
    # for delayed job delta index
    add_column :pages, :delta, :boolean, :default => true, :null => false
    add_column :uploaded_files, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :pages, :delta
    remove_column :uploaded_files, :delta
  end
end

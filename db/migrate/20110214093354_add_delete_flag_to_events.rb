class AddDeleteFlagToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :deleted, :boolean, :default => false
    Event.update_all ["deleted = ?", false]
  end

  def self.down
    remove_column :events, :deleted
  end
end

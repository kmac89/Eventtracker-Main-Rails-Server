class ChangeEventUserIdToUuid < ActiveRecord::Migration
  def self.up
    remove_column :events, :user_id
    add_column :events, :user_uuid, :string
  end

  def self.down
    add_column :events, :user_id, :integer
    remove_column :events, :user_uuid
  end
end

class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :id => false do |t|
      t.string :uuid, :limit => 36, :primary => true
      t.string :content
      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

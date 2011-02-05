class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :uuid, :limit => 36
      t.string :content
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

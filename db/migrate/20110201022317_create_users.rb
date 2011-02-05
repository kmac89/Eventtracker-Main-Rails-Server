class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :uuid, :limit => 36
      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

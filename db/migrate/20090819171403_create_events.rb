class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :location_id
      t.integer :member_id

      t.datetime :starts_at
      t.datetime :ends_at

      t.string :name, :limit => 128
      t.string :status, :limit => 64
      t.string :agenda, :limit => 16384
      t.string :minutes, :limit => 16384

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

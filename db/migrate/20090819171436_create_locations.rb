class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name, :limit => 128
      t.string :homepage, :limit => 256

      t.string :address, :limit => 1024

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end

class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name, :limit => 128
      t.string :email, :limit => 512
      t.string :password, :limit => 256
      t.string :feed_url, :limit => 512
      t.string :irc_nick, :limit => 128
      t.string :persistence_token, :limit => 1024
      t.string :about, :limit => 16384

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end

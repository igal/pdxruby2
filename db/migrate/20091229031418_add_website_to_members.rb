class AddWebsiteToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :website, :string, :limit => 1024
  end

  def self.down
    remove_column :members, :website
  end
end

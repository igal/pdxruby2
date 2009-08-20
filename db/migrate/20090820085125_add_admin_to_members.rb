class AddAdminToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :members, :admin
  end
end

class AddSpammerToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :spammer, :boolean, :default => false
    Member.update_all(:spammer => false)
  end

  def self.down
    remove_column :members, :spammer
  end
end

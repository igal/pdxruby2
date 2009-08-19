class AddCancelledToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :cancelled, :boolean, :default => false

    Event.reset_column_information

    Event.all.each do |event|
      event.cancelled = (event.status == "cancelled")
      event.save!
    end
  end

  def self.down
    remove_column :events, :cancelled, :boolean
  end
end

#!./script/runner

class OldMember < ActiveRecord::Base
  set_table_name "members"
  establish_connection "old"
end

class OldEvent < ActiveRecord::Base
  set_table_name "events"
  establish_connection "old"
end

class OldLocation < ActiveRecord::Base
  set_table_name "locations"
  establish_connection "old"
end

puts
puts "MEMBERS:"
Member.destroy_all
OldMember.all.each do |o|
  n = Member.new(
    :name => o.name,
    :email => o.email,
    :feed_url => o.feed_url,
    :irc_nick => o.irc_nick,
    :about => o.about)
  n.write_attribute(:id, o.id)
  n.write_attribute(:persistence_token, nil)
  n.write_attribute(:password, o.password)
  puts "- #{n.name}"
  begin
    n.save!
  rescue Exception => e
    puts "ERROR: #{e}"
    require 'rubygems'; require 'ruby-debug'; Debugger.start; debugger; 1
  end
end
counter = Member.connection.select_value('select max(id) from members').to_i + 1
Member.connection.execute("ALTER SEQUENCE members_id_seq RESTART WITH #{counter}")

puts
puts "LOCATIONS"
Location.destroy_all
OldLocation.all.each do |o|
  n = Location.new(
    :name => o.name,
    :homepage => o.homepage,
    :address => o.address,
    :created_at => o.created_at)
  n.write_attribute(:id, o.id)
  puts "- #{n.name}"
  begin
    n.save!
  rescue Exception => e
    puts "ERROR: #{e}"
    require 'rubygems'; require 'ruby-debug'; Debugger.start; debugger; 1
  end
end
counter = Location.connection.select_value('select max(id) from locations').to_i + 1
Location.connection.execute("ALTER SEQUENCE locations_id_seq RESTART WITH #{counter}")

puts
puts "EVENTS"
Event.destroy_all
OldEvent.all.each do |o|
  n = Event.new(
    :name => o.name,
    :agenda => o.agenda,
    :minutes => o.minutes,

    :location_id => o.location_id,
    :member_id => o.member_id,

    :starts_at => o.starts_at,
    :ends_at => o.ends_at,

    :cancelled => o.status == "cancelled",
    :created_at => o.created_at)
  n.write_attribute(:id, o.id)
  puts "- #{n.name}"
  begin
    n.save!
  rescue Exception => e
    puts "ERROR: #{e}"
    require 'rubygems'; require 'ruby-debug'; Debugger.start; debugger; 1
  end
end
counter = Event.connection.select_value('select max(id) from events').to_i + 1
Event.connection.execute("ALTER SEQUENCE events_id_seq RESTART WITH #{counter}")

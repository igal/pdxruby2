module HomeHelper
  def changes_for(version)
    changes = {}

    a = version.item_type.constantize.find(version.item_id) rescue nil
    b = version.reify

    if a.nil? && b.nil?
      b = version.next.reify # next?!
      unless b
      require 'rubygems'; require 'ruby-debug'; Debugger.start; debugger; 1 # FIXME
      end
        #a = version.item_type.constantize.new
    end

    (a or b).attribute_names.each do |name|
      next if name == "updated_at"
      next if name == "created_at"
      avalue = a.read_attribute(name) if a
      bvalue = b.read_attribute(name) if b
      unless avalue == bvalue
        changes[name] = [avalue, bvalue]
      end
    end

    return changes
  end
end

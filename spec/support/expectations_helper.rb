class Expector

  attr_accessor :options, :debug, :changes, :preserves, :creates, :destroys, :emails, :original_values, :original_counts, :original_email_count
  
  def initialize options={}
    self.options = options
  end

  def set_expectations!

    self.debug = options.delete(:debug)
    
    if self.changes = (options.delete(:change) || options.delete(:changes))
      raise "The :changes key must point at a Hash with keys that are objects that will change and values that describe the changes" unless changes.is_a?(Hash)
      changes.each_pair do |obj, change|
        raise "The object #{obj.inspect} you are watching for changes must respond to the 'reload' method." unless obj.respond_to?(:reload)
        raise "The change for object #{obj.inspect} must be a Hash of values with keys that are the object's fields and values which are those fields' new values" unless change.is_a?(Hash)
        change.keys.each do |key|
          raise "The object #{obj.inspect} you expect to change must respond to a method named '#{key}'" unless obj.respond_to?(key)
        end
      end
    end

    if self.preserves = (options.delete(:preserve) || options.delete(:preserves))
      raise "The :preserves key must point at a Hash with keys that are objects and values that describe which fields will remain unchanged " unless preserves.is_a?(Hash)
      self.original_values = {}.tap do |all|
        preserves.each_pair do |obj, fields|
          raise "The object #{obj.inspect} you are watching for changes must respond to the 'reload' method." unless obj.respond_to?(:reload)
          fields = [fields].flatten
          all[obj] = {}.tap do |this|
            fields.each do |field|
              this[field] = obj.send(field)
            end
          end
        end
      end
    end

    self.creates  = (options.delete(:create)  || options.delete(:creates))
    self.destroys = (options.delete(:destroy) || options.delete(:destroys))

    if (creates || destroys)
      self.original_counts = {}
      [].tap do |types|
        types << creates.keys  if creates
        types << destroys.keys if destroys
      end.flatten.uniq.each do |type|
        original_counts[type.to_s.classify] = type.to_s.classify.constantize.count
      end
    end

    self.emails = (options.delete(:email) || options.delete(:emails))
    if emails
      self.original_email_count = ActionMailer::Base.deliveries.size
    end
  end

  def confirm_expectations!
    if preserves
      original_values.each_pair do |obj, ovs|
        obj.reload
        ovs.each_pair do |field, ov|
          obj.send(field).should == ov
        end
      end
    end

    if changes
      changes.each_pair do |obj, changes|
        obj.reload
        changes.each_pair do |field, value|
          obj.send(field).should == value
        end
      end
    end

    if creates
      creates.each_pair do |type, count|
        type.to_s.classify.constantize.count.should == (original_counts[type.to_s.classify] + count)
      end
    end

    if destroys
      destroys.each_pair do |type, count|
        type.to_s.classify.constantize.count.should == (original_counts[type.to_s.classify] - count)
      end
    end

    if emails
      (ActionMailer::Base.deliveries.size - original_email_count).should == emails
    end
  end
end

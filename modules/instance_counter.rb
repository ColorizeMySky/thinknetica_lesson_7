module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances_count

    def instances
      @instances_count ||= 0
    end

    def increment_instances_count
      @instances_count += 1
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.increment_instances_count
    end
  end
end
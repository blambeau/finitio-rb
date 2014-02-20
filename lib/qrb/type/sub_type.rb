module Qrb
  class SubType < Type

    DEFAULT_CONSTRAINT_NAMES = [:default, :predicate].freeze

    def initialize(name, super_type, constraints)
      unless super_type.is_a?(Type)
        raise ArgumentError, "Qrb::Type expected, got #{super_type}"
      end

      unless constraints.is_a?(Hash)
        raise ArgumentError, "Hash expected for constraints, got #{constraints}"
      end

      super(name)
      @super_type, @constraints = super_type, constraints.freeze
    end
    attr_reader :super_type, :constraints

    def up(value, handler = UpHandler.new)
      # Check that the supertype is able to up the value.
      # Rewrite and set cause to any encountered UpError.
      uped = handler.try(self, value) do
        super_type.up(value, handler)
      end

      # Check each constraint in turn
      constraints.each_pair do |name, constraint|
        next if constraint===uped
        msg = handler.default_error_message(self, value)
        msg << " (not #{name})" unless DEFAULT_CONSTRAINT_NAMES.include?(name)
        handler.fail!(msg)
      end

      # seems good, return the uped value
      uped
    end

    def ==(other)
      return false unless other.is_a?(SubType)
      other.super_type == super_type and \
      set_equal?(constraints.values, other.constraints.values)
    end
    alias :eql? :==

    def hash
      self.class.hash ^ super_type.hash ^ set_hash(constraints.values)
    end

  end # class BuiltinType
end # module Qrb

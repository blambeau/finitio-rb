module Finitio
  class Compilation

    def initialize(system = System.new, factory = TypeFactory.new)
      @system  = system
      @factory = factory
    end
    attr_reader :system, :factory

    def self.coerce(arg)
      case arg
      when NilClass    then new
      when System      then new(arg, arg.factory)
      when TypeFactory then new(System.new, arg)
      else
        raise ArgumentError, "Unable to coerce `#{arg}`"
      end
    end

    # Delegation to Factory

    TypeFactory::DSL_METHODS.each do |dsl_method|
      define_method(dsl_method){|*args, &bl|
        factory.public_send(dsl_method, *args, &bl)
      }
    end

    # Delegation to System

    [
      :add_type,
      :fetch,
      :main,
      :main=
    ].each do |meth|
      define_method(meth) do |*args, &bl|
        system.public_send(meth, *args, &bl)
      end
    end

  end # class Compilation
end # module Finitio
module Rocknab
  module Builders
    class Text < Struct.new(:name, :length, :default, :padding)
      def build(klass)
        value = klass.instance_variable_get("@#{name}") || default
        value.to_s.upcase[0...length].ljust(length, padding.to_s)
      end
    end
  end
end

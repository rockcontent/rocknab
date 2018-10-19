module Rocknab
  module Builders
    class Number < Struct.new(:name, :length, :default, :padding)
      def build(klass)
        value = klass.instance_variable_get("@#{name}") || default
        value.to_s[0...length].rjust(length, padding.to_s)
      end
    end
  end
end

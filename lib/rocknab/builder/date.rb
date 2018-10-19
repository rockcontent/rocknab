module Rocknab
  module Builders
    class Date < Struct.new(:name, :length, :default, :padding)
      def build(klass)
        value = klass.instance_variable_get("@#{name}") || default
        str_value = value.strftime("%d%m%Y%H%M%S")
        str_value[0...length].ljust(length, padding.to_s)
      end
    end
  end
end

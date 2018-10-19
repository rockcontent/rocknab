module Rocknab
  module Builders
    class Padding < Struct.new(:length, :default)
      def build(klass)
        default.to_s * length
      end
    end
  end
end

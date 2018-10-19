module Rocknab
  module Layouts
    module CNAB240
      class Trailer < Rocknab::Builder
        number :bank_code, length: 3, default: 0
        number :batch_index, length: 4, default: 9999
        number :register_type, length: 1, default: 9

        padding length: 9

        number :batch_count, length: 6, default: 1
        number :register_count, length: 6

        padding length: 211
      end
    end
  end
end

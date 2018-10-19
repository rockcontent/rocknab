module Rocknab
  module Layouts
    module CNAB240
      class BatchTrailer < Rocknab::Builder
        number :bank_code, length: 3, default: 0
        number :batch_index, length: 4, default: 1
        number :register_type, length: 1, default: 5

        padding length: 9

        number :register_count, length: 6
        number :total_sum, length: 18

        padding length: 18, char: "0"
        padding length: 171

        text :return_code, length: 10
      end
    end
  end
end

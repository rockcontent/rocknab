module Rocknab
  module Layouts
    module CNAB240
      class Segment < Rocknab::Builder
        number :bank_code, length: 3, default: 0
        number :batch_index, length: 4, default: 1
        number :register_type, length: 1, default: 3
        number :segment_index, length: 5, default: 1

        text :segment_type, length: 1, default: "A"
        number :service_type, length: 3, default: 0
        number :camara, length: 3, default: "009"

        number :bank, length: 3, default: 0
        number :branch, length: 5

        padding length: 1

        number :account, length: 12

        padding length: 1

        number :digit, length: 1
        text :name, length: 30

        text :document_number, length: 20
        date :date, length: 8
        text :currency_type, length: 3, default: "REA"

        padding length: 8, char: "0"
        number :transfer_type, length: 2, default: "01"
        padding length: 5, char: "0"

        number :value, length: 15
        text :our_number, length: 15

        padding length: 5

        number :actual_date, length: 8
        number :actual_value, length: 15

        text :cnpj_number, length: 14

        padding length: 6

        number :operation_number, length: 6
        number :inscription_number, length: 14
        text :doc_type, length: 2
        text :ted_type, length: 5

        text :complement, length: 5
        text :notice, length: 1, default: "0"
        text :occurrencies, length: 10
      end
    end
  end
end

module Rocknab
  module Layouts
    module CNAB240
      class BatchHeader < Rocknab::Builder
        number :bank_code, length: 3, default: 0
        number :batch_index, length: 4, default: 1
        number :register_type, length: 1, default: 1

        text :operation_type, length: 1, default: "C"
        number :payment_type, length: 2, default: 98
        number :payment_method, length: 2, default: 1
        number :batch_layout, length: 3, default: 40

        padding length: 1

        number :company_type, length: 1, default: 2
        number :cnpj, length: 14
        text :indentification, length: 4

        padding length: 16

        number :branch, length: 5

        padding length: 1

        number :account, length: 12

        padding length: 1

        text :digit, length: 1
        text :name, length: 30

        text :payment_reason, length: 30, default: "01"
        text :account_history, length: 10

        text :street, length: 30
        number :number, length: 5
        text :type, length: 15
        text :city, length: 20
        text :zipcode, length: 8
        text :state, length: 2

        padding length: 8

        text :return_code, length: 10
      end
    end
  end
end

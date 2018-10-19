module Rocknab
  module Layouts
    module CNAB240
      class Header < Rocknab::Builder
        number :bank_code, length: 3, default: 0
        number :batch_index, length: 4, default: 0
        number :register_type, length: 1, default: 0

        padding length: 6

        number :file_version, length: 3, default: 80

        number :company_type, length: 1, default: 2
        number :cnpj, length: 14

        padding length: 20

        number :branch, length: 5

        padding length: 1

        number :account, length: 12

        padding length: 1

        number :digit, length: 1
        text :name, length: 30
        text :bank, length: 30

        padding length: 10

        number :file_type, length: 1, default: 1
        date :date, length: 14

        padding length: 9, char: "0"

        number :density_unit, length: 5

        padding length: 69
      end
    end
  end
end

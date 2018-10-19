require_relative "../builder"
require_relative "cnab_240/header"
require_relative "cnab_240/batch"
require_relative "cnab_240/trailer"

module Rocknab
  module Layouts
    module CNAB240
      # This is the class that builds a CNAB240 file.
      #
      # Parameters:
      #  - params: A hash containing the following values:
      #    :cnpj, :branch, :account, :digit, :name, :bank, :date,
      #    :zipcode, :state
      #  - payments: An array of hashes, each with the following:
      #    :bank, :branch, :account, :digit, :name, :date, :value
      #
      # Usage:
      #
      #   cnab = CNAB240.new(params, payments)
      #   cnab.build
      #   => "... CNAB content ..."
      class CNAB240 < Struct.new(:params, :payments)
        HEADER_PARAMS = [ :bank_code, :cnpj, :branch, :account, :digit, :name,
          :bank, :date ]
        TRAILER_PARAMS = [ :bank_code ]

        # Builds the CNAB 240 v81 file according to the contents
        #
        # Usage:
        #
        #  cnab.build
        #  => "... CNAB content ..."
        def build
          [ header, batches, trailer, nil ].join("\r\n")
        end

        private

        def header
          Header.new(params.slice(*HEADER_PARAMS)).build
        end

        def batches
          batch_groups.each_with_index.map do |group, index|
            config, batch_payments = group
            is_same_bank = config[:is_same_bank]
            is_ted = config[:is_ted]
            is_savings = config[:is_savings]
            Batch.new(params, batch_payments, is_same_bank, is_ted, is_savings, index + 1).build
          end
        end

        def batch_groups
          payments.group_by do |payment|
            is_same_bank = payment.dig(:bank) === params.dig(:bank_code)
            is_ted = payment.dig(:is_ted)
            is_savings = payment.dig(:is_savings)

            {
              is_same_bank: is_same_bank,
              is_ted: !is_same_bank && is_ted,
              is_savings: is_savings,
            }
          end
        end

        def trailer
          default_params = {
            register_count: batches.flatten.count + 2,
            batch_count: batches.length
          }
          line_params = params.slice(*TRAILER_PARAMS).merge(default_params)

          Trailer.new(line_params).build
        end
      end
    end
  end
end

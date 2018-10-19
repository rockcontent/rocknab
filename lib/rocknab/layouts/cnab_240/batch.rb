require_relative "batch_header"
require_relative "batch_trailer"
require_relative "segment"

module Rocknab
  module Layouts
    module CNAB240
      class Batch < Struct.new(:params, :payments, :is_same_bank, :is_ted, :is_savings,
        :batch_index)
        BATCH_PARAMS = [ :bank_code, :cnpj, :branch, :account, :digit, :name,
          :zipcode, :state, :payment_type, :payment_reason ]
        SEGMENT_PARAMS = [ :bank_code, :bank, :branch, :account, :digit, :name,
          :date, :value, :inscription_number ]
        TRAILER_PARAMS = [ :bank_code ]

        def build
          [ batch_header, segments, batch_trailer ]
        end

        private

        def batch_header
          default_params = {
            batch_index: batch_index,
            payment_method: payment_method,
          }
          line_params = params.slice(*BATCH_PARAMS).merge(default_params)

          BatchHeader.new(line_params).build
        end

        def segments
          payments.each_with_index.map do |payment, index|
            default_params = {
              batch_index: batch_index,
              segment_index: index + 1,
              bank_code: params.dig(:bank_code),
              doc_type: doc_type,
            }
            line_params = payment.slice(*SEGMENT_PARAMS).merge(default_params)

            Segment.new(line_params).build
          end
        end

        def batch_trailer
          default_params = {
            batch_index: batch_index,
            register_count: register_count,
            total_sum: total_sum,
          }
          line_params = params.slice(*TRAILER_PARAMS).merge(default_params)

          BatchTrailer.new(line_params).build
        end

        def payment_method
          if is_same_bank && is_savings
            5
          elsif is_same_bank
            1
          elsif is_ted
            41
          else
            3
          end
        end

        def doc_type
          if is_savings && !is_same_bank
            "11"
          else
            ""
          end
        end

        def register_count
          payments.count + 2
        end

        def total_sum
          payments.inject(0) do |sum, payment|
            sum + payment.dig(:value)
          end
        end
      end
    end
  end
end

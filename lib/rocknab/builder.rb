require_relative "builder/text"
require_relative "builder/number"
require_relative "builder/date"
require_relative "builder/padding"

module Rocknab
  # This is the DSL that is used to declare CNAB registers
  #
  # Declaration:
  #
  #   class MyRegister < Rocknab::Builder
  #     text :txt_field, length: 4
  #     number :num_field, length: 2
  #   end
  #
  # To use the class:
  #
  #   register = MyRegister.new(txt_field: "text", num_field: 10)
  #   register.build
  #   => "TEXT10"
  class Builder
    # Subclasses can be initialized with the arguments passed as a
    # hash, just like a Struct.
    #
    # Usage:
    #
    #   MyRegister.new(txt_field: "text", num_field: 10)
    def initialize(**args)
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # Builds the class according to the definition
    #
    # Usage:
    #
    #   register.build
    #   => "TEXT10"
    def build
      self.class.metadata.map do |field|
        field.build(self)
      end.join
    end

    # Declares that the generated content has a text field
    #
    # Parameters:
    #  - name: Name of the field accessors
    #  - length: Fixed length of the field
    #  - default: Default value. Empty if not specified.
    #  - padding: Padding character. Whitespace, if not specified.
    #
    # Usage:
    #
    #   class MyRegister < Rocknab::Builder
    #     text :my_field, length: 20, default: "hello", padding: " "
    #   end
    def self.text(name, length: 1, default: " ", padding: " ")
      metadata << Builders::Text.new(name, length, default, padding)
      attr_accessor(name)
    end

    # Declares that the generated content has a numeric field.
    # This field should only be used for integers.
    #
    # Parameters:
    #  - name: Name of the field accessors
    #  - length: Fixed length of the field
    #  - default: Default value. Zero if not specified.
    #  - padding: Padding character. Zeros, if not specified.
    #
    # Usage:
    #
    #   class MyRegister < Rocknab::Builder
    #     number :my_num, length: 20, default: 1234, padding: 0
    #   end
    def self.number(name, length: 1, default: 0, padding: 0)
      metadata << Builders::Number.new(name, length, default, padding)
      attr_accessor(name)
    end

    # Declares that the generated content has a date field. The
    # format is DDMMYYYYhhmmss.
    #
    # Parameters:
    #  - name: Name of the field accessors
    #  - length: Fixed length of the field. Default is 14.
    #  - default: Default value. Zeroes if not specified.
    #  - padding: Padding character. Zeros, if not specified.
    #
    # Tip: Use 10 as the length, if you only need the date.
    #
    # Usage:
    #
    #   class MyRegister < Rocknab::Builder
    #     date :created_at, length: 14, default: "hello", padding: " "
    #   end
    def self.date(name, length: 14, default: 0, padding: 0)
      metadata << Builders::Date.new(name, length, default, padding)
      attr_accessor(name)
    end

    # Declares that the generated content has a padding
    #
    # Parameters:
    #  - length: Fixed length of the field
    #  - char: Character that will be used to pad the content.
    #          The default is whitespace.
    #
    # Usage:
    #
    #   padding length: 10, char: "0"
    def self.padding(length: 1, char: " ")
      metadata << Builders::Padding.new(length, char)
    end

    # Returns the total length of the fields. Useful for validation
    # purposes and testing.
    #
    # Usage:
    #
    #   MyRegister.length
    #   => 240
    def self.length
      metadata.map(&:length).reduce(&:+)
    end

    def self.inherited(child)
      child.instance_eval do
        class << self
          attr_accessor :metadata
        end
      end

      child.metadata = []
    end
  end
end

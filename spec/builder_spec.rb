require "rocknab/builder"

RSpec.describe Rocknab::Builder do
  context "when extended" do
    let(:klass) { Class.new(Rocknab::Builder) }

    describe "#metadata" do
      it "adds a metadata attribute" do
        expect(klass).to respond_to(:metadata)
      end

      it "adds empty metadata" do
        expect(klass.metadata).to eq([])
      end
    end

    describe "#text" do
      it "is added to the class methods" do
        expect(klass).to respond_to(:text)
      end

      it "adds an accessor to objects" do
        klass.text :field

        expect(klass.new).to respond_to(:field)
        expect(klass.new).to respond_to(:field=)
      end

      it "adds an accessor that stores text" do
        klass.text(:field)
        object = klass.new(field: "my_text")

        expect(object.field).to eq("my_text")
      end

      it "adds metadata to the class" do
        klass.text(:field)

        expect(klass.metadata.first.class.name).to include("Text")
        expect(klass.metadata.first.name).to eq(:field)
      end
    end

    describe "#number" do
      it "is added to the class methods" do
        expect(klass).to respond_to(:number)
      end

      it "adds an accessor to objects" do
        klass.number(:field)

        expect(klass.new).to respond_to(:field)
        expect(klass.new).to respond_to(:field=)
      end

      it "adds an accessor that stores numbers" do
        klass.number(:field)
        object = klass.new(field: 1234)

        expect(object.field).to eq(1234)
      end

      it "adds metadata to the class" do
        klass.number(:field)

        expect(klass.metadata.first.class.name).to include("Number")
        expect(klass.metadata.first.name).to eq(:field)
      end
    end

    describe "#date" do
      it "is added to the class methods" do
        expect(klass).to respond_to(:date)
      end

      it "adds an accessor to objects" do
        klass.date(:field)

        expect(klass.new).to respond_to(:field)
        expect(klass.new).to respond_to(:field=)
      end

      it "adds an accessor that stores numbers" do
        klass.date(:field)
        object = klass.new(field: Time.new(2017, 1, 1))

        expect(object.field).to eq(Time.new(2017, 1, 1))
      end

      it "adds metadata to the class" do
        klass.date(:field)

        expect(klass.metadata.first.class.name).to include("Date")
        expect(klass.metadata.first.name).to eq(:field)
      end
    end

    describe "#padding" do
      it "is added to the class methods" do
        expect(klass).to respond_to(:padding)
      end

      it "doesn't add accessors to objects" do
        klass.padding

        expect(klass.new).not_to respond_to(:field)
        expect(klass.new).not_to respond_to(:field=)
      end

      it "adds metadata to the class" do
        klass.padding

        expect(klass.metadata.first.class.name).to include("Padding")
        expect(klass.metadata.first).not_to respond_to(:name)
      end
    end

    describe "#length" do
      it "returns the sum of all lengths" do
        klass.number(:field1, length: 10)
        klass.padding(length: 8)
        klass.text(:field2, length: 6)

        expect(klass.length).to eq(10 + 8 + 6)
      end
    end

    describe "#build" do
      describe "when using default values" do
        it "concatenates the defaults as configured" do
          klass.number(:field1, length: 10)
          klass.padding(length: 8)
          klass.text(:field2, length: 6)

          expect(klass.new.build).to eq("0000000000              ")
        end
      end

      describe "after setting the values" do
        it "concatenates the values as configured" do
          klass.number(:field1, length: 10)
          klass.padding(length: 8)
          klass.text(:field2, length: 6)

          object = klass.new(field1: 10, field2: "hello")

          expect(object.build).to eq("0000000010        HELLO ")
        end
      end
    end

    describe "#initializer" do
      describe "without parameters" do
        it "works normally" do
          klass.text(:field1)

          object = klass.new

          expect(object.field1).to eq(nil)
        end
      end

      describe "with parameters" do
        it "sets instance variables" do
          klass.text(:field1)
          klass.text(:field2)

          object = klass.new(field1: 1, field2: 2)

          expect(object.field1).to eq(1)
          expect(object.field2).to eq(2)
        end
      end
    end
  end
end

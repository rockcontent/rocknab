require "rocknab/builder"
require "rocknab/layouts/cnab_240"

RSpec.describe Rocknab::Layouts::CNAB240::CNAB240 do
  context "with a single payment to the same bank (money transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 30,
        payment_reason: "01",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C3001040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA01                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with a single payment to a savings account in the same bank (money transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 30,
        payment_reason: "01",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_savings: true,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C3005040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA01                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with a single payment to a savings account in ANOTHER bank" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 30,
        payment_reason: "01",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_savings: true,
          inscription_number: 12342345345,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C3003040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA01                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    0000000001234234534511          0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with multiple payments to the same bank (money transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 30,
        payment_reason: "01",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        },
        {
          bank: 341,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
        },
        {
          bank: 341,
          branch: 3117,
          account: 10867,
          digit: 4,
          name: "NEADRM N EGASENIAIONETA SAOSI",
          date: Time.new(2017, 11, 30),
          value: 130000,
        },
        {
          bank: 341,
          branch: 925,
          account: 14164,
          digit: 0,
          name: "DVADAIDWOAA A TLVZGVECDAA SUC",
          date: Time.new(2017, 11, 30),
          value: 68900,
        },
        {
          bank: 341,
          branch: 925,
          account: 13356,
          digit: 3,
          name: "LAADAMAANJ RDRTINAN RAO FOAEE",
          date: Time.new(2017, 11, 30),
          value: 139600,
        },
        {
          bank: 341,
          branch: 3176,
          account: 63200,
          digit: 2,
          name: "AEALENAN GNCASO VOLGREOAENR C",
          date: Time.new(2017, 11, 30),
          value: 274900,
        },
        {
          bank: 341,
          branch: 925,
          account: 13497,
          digit: 5,
          name: "RNAMRSANOCEIRSAE EAUISARRELT O",
          date: Time.new(2017, 11, 30),
          value: 50900,
        },
        {
          bank: 341,
          branch: 6313,
          account: 13677,
          digit: 9,
          name: "READIIDAA  CI  OUVLI SIR T VEA",
          date: Time.new(2017, 11, 30),
          value: 45200,
        },
      ]

      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C3001040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA01                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
3410001300002A00000034100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
3410001300003A00000034103117 000000010867 4NEADRM N EGASENIAIONETA SAOSI                     30112017REA000000000000000000000000130000                    00000000000000000000000                    00000000000000000000            0
3410001300004A00000034100925 000000014164 0DVADAIDWOAA A TLVZGVECDAA SUC                     30112017REA000000000000000000000000068900                    00000000000000000000000                    00000000000000000000            0
3410001300005A00000034100925 000000013356 3LAADAMAANJ RDRTINAN RAO FOAEE                     30112017REA000000000000000000000000139600                    00000000000000000000000                    00000000000000000000            0
3410001300006A00000034103176 000000063200 2AEALENAN GNCASO VOLGREOAENR C                     30112017REA000000000000000000000000274900                    00000000000000000000000                    00000000000000000000            0
3410001300007A00000034100925 000000013497 5RNAMRSANOCEIRSAE EAUISARRELT O                    30112017REA000000000000000000000000050900                    00000000000000000000000                    00000000000000000000            0
3410001300008A00000034106313 000000013677 9READIIDAA  CI  OUVLI SIR T VEA                    30112017REA000000000000000000000000045200                    00000000000000000000000                    00000000000000000000            0
34100015         000010000000000000857000000000000000000000
34199999         000001000012
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with a single payment to another bank (TED transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_ted: true,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9841040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with a single payment to another bank (PIX transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_pix: true,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9845040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
      END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with multiple payments to another bank (PIX transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 3117,
          account: 10867,
          digit: 4,
          name: "NEADRM N EGASENIAIONETA SAOSI",
          date: Time.new(2017, 11, 30),
          value: 130000,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 14164,
          digit: 0,
          name: "DVADAIDWOAA A TLVZGVECDAA SUC",
          date: Time.new(2017, 11, 30),
          value: 68900,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13356,
          digit: 3,
          name: "LAADAMAANJ RDRTINAN RAO FOAEE",
          date: Time.new(2017, 11, 30),
          value: 139600,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 3176,
          account: 63200,
          digit: 2,
          name: "AEALENAN GNCASO VOLGREOAENR C",
          date: Time.new(2017, 11, 30),
          value: 274900,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13497,
          digit: 5,
          name: "RNAMRSANOCEIRSAE EAUISARRELT O",
          date: Time.new(2017, 11, 30),
          value: 50900,
          is_pix: true,
        },
        {
          bank: 1,
          branch: 6313,
          account: 13677,
          digit: 9,
          name: "READIIDAA  CI  OUVLI SIR T VEA",
          date: Time.new(2017, 11, 30),
          value: 45200,
          is_pix: true,
        },
      ]

      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9845040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
3410001300002A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
3410001300003A00000000103117 000000010867 4NEADRM N EGASENIAIONETA SAOSI                     30112017REA000000000000000000000000130000                    00000000000000000000000                    00000000000000000000            0
3410001300004A00000000100925 000000014164 0DVADAIDWOAA A TLVZGVECDAA SUC                     30112017REA000000000000000000000000068900                    00000000000000000000000                    00000000000000000000            0
3410001300005A00000000100925 000000013356 3LAADAMAANJ RDRTINAN RAO FOAEE                     30112017REA000000000000000000000000139600                    00000000000000000000000                    00000000000000000000            0
3410001300006A00000000103176 000000063200 2AEALENAN GNCASO VOLGREOAENR C                     30112017REA000000000000000000000000274900                    00000000000000000000000                    00000000000000000000            0
3410001300007A00000000100925 000000013497 5RNAMRSANOCEIRSAE EAUISARRELT O                    30112017REA000000000000000000000000050900                    00000000000000000000000                    00000000000000000000            0
3410001300008A00000000106313 000000013677 9READIIDAA  CI  OUVLI SIR T VEA                    30112017REA000000000000000000000000045200                    00000000000000000000000                    00000000000000000000            0
34100015         000010000000000000857000000000000000000000
34199999         000001000012
      END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with multiple payments to another bank (TED transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 3117,
          account: 10867,
          digit: 4,
          name: "NEADRM N EGASENIAIONETA SAOSI",
          date: Time.new(2017, 11, 30),
          value: 130000,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 14164,
          digit: 0,
          name: "DVADAIDWOAA A TLVZGVECDAA SUC",
          date: Time.new(2017, 11, 30),
          value: 68900,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13356,
          digit: 3,
          name: "LAADAMAANJ RDRTINAN RAO FOAEE",
          date: Time.new(2017, 11, 30),
          value: 139600,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 3176,
          account: 63200,
          digit: 2,
          name: "AEALENAN GNCASO VOLGREOAENR C",
          date: Time.new(2017, 11, 30),
          value: 274900,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13497,
          digit: 5,
          name: "RNAMRSANOCEIRSAE EAUISARRELT O",
          date: Time.new(2017, 11, 30),
          value: 50900,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 6313,
          account: 13677,
          digit: 9,
          name: "READIIDAA  CI  OUVLI SIR T VEA",
          date: Time.new(2017, 11, 30),
          value: 45200,
          is_ted: true,
        },
      ]

      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9841040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
3410001300002A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
3410001300003A00000000103117 000000010867 4NEADRM N EGASENIAIONETA SAOSI                     30112017REA000000000000000000000000130000                    00000000000000000000000                    00000000000000000000            0
3410001300004A00000000100925 000000014164 0DVADAIDWOAA A TLVZGVECDAA SUC                     30112017REA000000000000000000000000068900                    00000000000000000000000                    00000000000000000000            0
3410001300005A00000000100925 000000013356 3LAADAMAANJ RDRTINAN RAO FOAEE                     30112017REA000000000000000000000000139600                    00000000000000000000000                    00000000000000000000            0
3410001300006A00000000103176 000000063200 2AEALENAN GNCASO VOLGREOAENR C                     30112017REA000000000000000000000000274900                    00000000000000000000000                    00000000000000000000            0
3410001300007A00000000100925 000000013497 5RNAMRSANOCEIRSAE EAUISARRELT O                    30112017REA000000000000000000000000050900                    00000000000000000000000                    00000000000000000000            0
3410001300008A00000000106313 000000013677 9READIIDAA  CI  OUVLI SIR T VEA                    30112017REA000000000000000000000000045200                    00000000000000000000000                    00000000000000000000            0
34100015         000010000000000000857000000000000000000000
34199999         000001000012
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with payments to the same and to the other bank (TED transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_ted: true,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9801040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34100021C9841040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410002300001A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
34100025         000003000000000000119600000000000000000000
34199999         000002000008
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with payments to the same and to the other bank (PIX transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_pix: true,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9801040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34100021C9845040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410002300001A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
34100025         000003000000000000119600000000000000000000
34199999         000002000008
      END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with a single payment to another bank (DOC transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 1,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
          is_ted: false,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9803040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000000100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34199999         000001000005
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with payments to the same and to the other bank (DOC transfer)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_ted: false,
        }
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9801040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34100021C9803040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410002300001A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
34100025         000003000000000000119600000000000000000000
34199999         000002000008
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end

  context "with payments to the same and to the other bank (both TED, PIX and DOC transfer this time)" do
    it "generates the correct output" do
      params = {
        bank_code: 341,
        cnpj: "16501060000128",
        name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
        branch: 3033,
        account: 6622,
        digit: 0,
        bank: "Itau S.A.",
        date: Time.new(2017, 11, 30, 11, 46, 18),
        zipcode: "13212240",
        state: "SP",
        payment_type: 98,
        payment_reason: "10",
      }

      payments = [
        {
          bank: 341,
          branch: 925,
          account: 12744,
          digit: 1,
          name: "CEADAIR EIROSRGPA N S BASSA",
          date: Time.new(2017, 11, 30),
          value: 27900,
        },
        {
          bank: 1,
          branch: 925,
          account: 13588,
          digit: 1,
          name: "RIAMRNSAADNBEES DILDSIOL A DJI",
          date: Time.new(2017, 11, 30),
          value: 119600,
          is_ted: true,
        },
        {
          bank: 1,
          branch: 925,
          account: 13497,
          digit: 5,
          name: "RNAMRSANOCEIRSAE EAUISARRELT O",
          date: Time.new(2017, 11, 30),
          value: 3000,
          is_ted: false,
        },
        {
          bank: 1,
          branch: 925,
          account: 13497,
          digit: 5,
          name: "RNAMRSANOCEIRSAE EAUISARRELT O",
          date: Time.new(2017, 11, 30),
          value: 3000,
          is_pix: true,
        },
      ]
      generator = described_class.new(params, payments)

      expected = <<-END
34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000
34100011C9801040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0
34100015         000003000000000000027900000000000000000000
34100021C9841040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410002300001A00000000100925 000000013588 1RIAMRNSAADNBEES DILDSIOL A DJI                    30112017REA000000000000000000000000119600                    00000000000000000000000                    00000000000000000000            0
34100025         000003000000000000119600000000000000000000
34100031C9803040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410003300001A00000000100925 000000013497 5RNAMRSANOCEIRSAE EAUISARRELT O                    30112017REA000000000000000000000000003000                    00000000000000000000000                    00000000000000000000            0
34100035         000003000000000000003000000000000000000000
34100041C9845040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA10                                                                    00000                                   13212240SP
3410004300001A00000000100925 000000013497 5RNAMRSANOCEIRSAE EAUISARRELT O                    30112017REA000000000000000000000000003000                    00000000000000000000000                    00000000000000000000            0
34100045         000003000000000000003000000000000000000000
34199999         000004000014
END

      expect(generator.build.gsub(/\s+$/, '')).to eq(expected.gsub("\n", "\r\n").gsub(/\s+$/, ''))
    end
  end
end

RSpec.describe Rocknab::Layouts::CNAB240::Header do
  it "should be 240 characters long" do
    expect(described_class.length).to eq(240)
  end

  it "should render the correct text" do
    header = described_class.new(
      bank_code: 341,
      cnpj: "16501060000128",
      branch: 3033,
      account: 6622,
      digit: 0,
      name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
      bank: "ITAU S.A.",
      date: Time.new(2017, 11, 30, 11, 46, 18),
    )

    expected = "34100000      080216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIAITAU S.A.                               13011201711461800000000000000"

    expect(header.build.strip).to eq(expected)
  end
end

RSpec.describe Rocknab::Layouts::CNAB240::BatchHeader do
  it "should be 240 characters long" do
    expect(described_class.length).to eq(240)
  end

  it "should render the correct text" do
    batch_header = described_class.new(
      bank_code: 341,
      payment_type: 30,
      payment_method: 1,
      cnpj: "16501060000128",
      branch: 3033,
      account: 6622,
      digit: 0,
      name: "ROCK CONTENT SERVIÇOS DE MIDIA LTDA",
      payment_reason: "01",
      zipcode: "13212240",
      state: "SP",
    )

    expected = "34100011C3001040 216501060000128                    03033 000000006622 0ROCK CONTENT SERVIÇOS DE MIDIA01                                                                    00000                                   13212240SP"

    expect(batch_header.build.strip).to eq(expected)
  end
end

RSpec.describe Rocknab::Layouts::CNAB240::Segment do
  it "should be 240 characters long" do
    expect(described_class.length).to eq(240)
  end

  it "should render the correct text" do
    segment = described_class.new(
      bank_code: 341,
      bank: 341,
      payment_index: 1,
      branch: 925,
      account: 12744,
      digit: 1,
      name: "CEADAIR EIROSRGPA N S BASSA",
      date: Time.new(2017, 11, 30),
      value: 27900,
    )

    expected = "3410001300001A00000034100925 000000012744 1CEADAIR EIROSRGPA N S BASSA                       30112017REA000000000000000000000000027900                    00000000000000000000000                    00000000000000000000            0"

    expect(segment.build.strip).to eq(expected)
  end
end

RSpec.describe Rocknab::Layouts::CNAB240::BatchTrailer do
  it "should be 240 characters long" do
    expect(described_class.length).to eq(240)
  end

  it "should render the correct text" do
    batch_trailer = described_class.new(
      bank_code: 341,
      register_count: 10,
      total_sum: 857000,
    )

    expected = "34100015         000010000000000000857000000000000000000000"

    expect(batch_trailer.build.strip).to eq(expected)
  end
end

RSpec.describe Rocknab::Layouts::CNAB240::Trailer do
  it "should be 240 characters long" do
    expect(described_class.length).to eq(240)
  end

  it "should render the correct text" do
    trailer = described_class.new(
      bank_code: 341,
      register_count: 12,
    )

    expected = "34199999         000001000012"

    expect(trailer.build.strip).to eq(expected)
  end
end

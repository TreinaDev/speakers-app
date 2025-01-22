require 'rails_helper'

describe DateTimeHelper, type: :helper do
  context '#formatted_date' do
    it 'must return correct date' do
      date = '2025-01-21'
      expect(helper.formatted_date(date)).to eq '21/01/2025'
    end

    it 'and return error if date value is incorrect' do
      date = 'something'
      expect(helper.formatted_date(date)).to eq 'Não foi possivel realizar a conversão da data: something'
    end

    it 'and return error if invalid format' do
      date = 10
      expect(helper.formatted_date(date)).to eq 'Formato não suportado'
    end
  end
end

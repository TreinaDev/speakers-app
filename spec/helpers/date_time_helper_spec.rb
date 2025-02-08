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

  context '#day' do
    it 'should return the day of the given date' do
      date = '2025-01-21'
      expect(helper.day(date)).to eq '21'
    end
  end

  context '#month' do
    it 'should return the month of the given date' do
      date = '2025-01-21'
      expect(helper.month(date)).to eq '01'
    end
  end

  context '#year' do
    it 'should return the year of the given date' do
      date = '2025-01-21'
      expect(helper.year(date)).to eq '2025'
    end
  end

  context '#month_name' do
    it 'should return the full month name in uppercase' do
      date = '2025-01-21'
      expect(helper.month_name(date)).to eq 'JANEIRO'
    end
  end

  context '#weekday' do
    it 'should return the weekday name of the given date' do
      date = '2025-01-21'
      expect(helper.weekday(date)).to eq 'terça-feira'
    end
  end

  context '#full_date' do
    it 'should return the full formatted date' do
      date = '2025-01-21'
      expect(helper.full_date(date)).to eq 'terça-feira, 21 de janeiro de 2025'
    end
  end
end

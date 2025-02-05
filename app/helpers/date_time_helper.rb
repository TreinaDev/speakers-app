module DateTimeHelper
  def formatted_date(datetime)
    return datetime.strftime("%d/%m/%Y") if datetime.is_a?(Time) || datetime.is_a?(Date)

    if datetime.is_a?(String)
      begin
        Date.parse(datetime).strftime("%d/%m/%Y")
      rescue ArgumentError
        t('helpers.date_time_error', datetime: datetime)
      end
    else
      "Formato não suportado"
    end
  end

  def day(date)
    formatted_date(date).split('/').first
  end

  def month(date)
    formatted_date(date).split('/')[1]
  end

  def year(date)
    formatted_date(date).split('/').last
  end

  def month_name(date)
    month = month(date)
    months = I18n.t('date.month_names')
    months[month.to_i].upcase
  end
end

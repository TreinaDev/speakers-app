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
end

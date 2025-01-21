module DateTimeHelper
  def formatted_date(datetime)
    datetime.strftime('%d/%m/%Y')
  end

  def formatted_hour(datetime)
    datetime.strftime('%H:%M')
  end
end

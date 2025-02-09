if @certificate.present?
  json.certificate_url certificate_url(@certificate.token)
end

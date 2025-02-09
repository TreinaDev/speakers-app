if @certificate.present?
  json.certificate_url certificate_pdf_url(@certificate.token)
end

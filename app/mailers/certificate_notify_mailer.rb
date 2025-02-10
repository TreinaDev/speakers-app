class CertificateNotifyMailer < ApplicationMailer
  default from: 'no-reply@palestramais.com'

  def send_certificate(participant_code:, participant_name:, participant_email:, schedule_item_code:)
    @participant_name = participant_name
    @schedule_item_code = schedule_item_code
    certificate = Certificate.find_by(participant_code: participant_code, schedule_item_code: schedule_item_code)
    @url  = certificate_pdf_url(certificate.token)
    mail(to: participant_email, subject: "Certificado Palestra +: #{ certificate.token }")
  end
end

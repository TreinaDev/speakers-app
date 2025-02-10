# Preview all emails at http://localhost:3000/rails/mailers/certificate_notify_mailer
class CertificateNotifyMailerPreview < ActionMailer::Preview
  def send_certificate
    participant_email = "test@email.com"
    participant_name = "John Doe"
    participant_code = "123456"
    schedule_item_code = "EVT-001"
    certificate = FactoryBot.create(:certificate, participant_code: participant_code, schedule_item_code: 'EVT-001')
    url = "http://example.com/certificate/#{certificate.token}"

    CertificateNotifyMailer.send_certificate(
      participant_code: participant_code,
      participant_name: participant_name,
      participant_email: participant_email,
      schedule_item_code: schedule_item_code,
    )
  end
end

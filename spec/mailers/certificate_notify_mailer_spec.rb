require "rails_helper"

RSpec.describe CertificateNotifyMailer, type: :mailer do
  describe "#send_certificate" do
    it "sends an email to the correct participant" do
      participant_email = "test@email.com"
      participant_name = "John Doe"
      participant_code = "123456"
      schedule_item_code = "EVT-001"
      certificate = create(:certificate, participant_code: participant_code, schedule_item_code: 'EVT-001')

      mail = CertificateNotifyMailer.send_certificate(
        participant_code: participant_code,
        participant_name: participant_name,
        participant_email: participant_email,
        schedule_item_code: schedule_item_code
      )

      expect(mail.to).to eq([ "test@email.com" ])
    end

    it "has the correct subject" do
      participant_email = "test@email.com"
      participant_name = "John Doe"
      participant_code = "123456"
      schedule_item_code = "EVT-001"
      certificate = create(:certificate, participant_code: participant_code, schedule_item_code: 'EVT-001')

      mail = CertificateNotifyMailer.send_certificate(
        participant_code: participant_code,
        participant_name: participant_name,
        participant_email: participant_email,
        schedule_item_code: schedule_item_code
      )

      expect(mail.subject).to eq("Certificado Palestra +: #{certificate.token}")
    end
  end
end

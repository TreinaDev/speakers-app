require 'rails_helper'

RSpec.describe EventCardHelper, type: :helper do
  describe '#event_card' do
    it 'renders the event card with correct structure' do
      event = build(:event, name: 'Ruby Conf', start_date: '2025-02-10', address: 'Main Street - 42', code: 'ABCD1234')
      html = helper.event_card(event)

      expect(html).to have_selector("li#ABCD1234.event__card")
      expect(html).to have_selector("h2.text-2xl", text: event.name)
      expect(html).to have_selector("img[src='/assets/default_image-b26ae1d8.jpeg']")
      expect(html).to have_selector("p.event__card-date-day", text: '10')
      expect(html).to have_selector("p.event__card-date-month", text: 'FEVEREIRO')
      expect(html).to have_selector("p.event__card-date-year", text: '2025')
      expect(html).to have_selector("p.event__card-address-name", text: 'Main Street - 42')
    end
  end
end

require 'rails_helper'

describe Api::V1::Invitees::Mailer, type: :mailer do
  describe 'send' do
    let(:invitation) { create(:invitation) }
    let(:message) { Faker::Lorem.paragraph }
    let(:email) { build(:invitee_email).decorate }
    let(:mail) { Api::V1::Invitees::Mailer.send_invitation(email) }

    it 'renders the subject' do
      expect(mail.subject).to eql(email.subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([email.to])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql([email.from])
    end

    it 'renders invitee first_name' do
      expect(mail.body.encoded).to match(email.invitee.first_name)
    end

    it 'renders inviter first_name' do
      expect(mail.body.encoded).to match(email.inviter.first_name)
    end

    it 'renders message' do
      expect(mail.body.encoded).to match(email.message)
    end
  end
end

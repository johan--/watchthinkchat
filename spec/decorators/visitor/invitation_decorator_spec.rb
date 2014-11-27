require 'rails_helper'

describe Visitor::InvitationDecorator, type: :decorator do
  let(:invitation) { create(:invitation).decorate }

  describe '.invite_url' do
    it 'returns full url' do
      expect(invitation.url).to match(/\A#{URI.regexp(%w(http https))}\z/)
    end
  end
end

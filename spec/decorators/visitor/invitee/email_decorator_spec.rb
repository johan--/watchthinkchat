require 'rails_helper'

describe Visitor::Invitee::EmailDecorator, type: :decorator do
  let(:invitee_email) { create(:invitee_email).decorate }
  it '#to returns invitee.email' do
    expect(invitee_email.to).to eq(invitee_email.invitee.email)
  end
  it '#from returns inviter.email' do
    expect(invitee_email.from).to eq(invitee_email.inviter.email)
  end
end

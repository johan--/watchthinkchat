require 'rails_helper'

RSpec.describe User::Translator::Invite, type: :model do
  # validations
  it { is_expected.to validate_presence_of :campaign }
  it { is_expected.to validate_presence_of :locale }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it 'is invalid with an erroneous email' do
    expect(build(:invite, email: Faker::Bitcoin.address)).not_to be_valid
  end

  context 'when a user does not exist' do
    let(:invite) { build(:invite) }
    it 'creates a new user object' do
      invite.save!
      expect(User).to exist
    end
    it 'send an invitation' do
      invite.save!
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].to_s).to eq(invite.email)
    end
  end
  context 'when a user does exist' do
    it 'does not send an invitation' do
      user = create(:user)
      invite = build(:invite, email: user.email)
      expect(User).to_not receive(:invite!)
      invite.save!
    end
  end
  context 'when a user is added as a translator' do
    let(:invite) { create(:invite) }
    it 'add translator role to invited user' do
      user = User.find_by(email: invite.email)
      expect(user.as(:translator)).to be_a(User::Translator)
    end
    it 'add permission to invited user' do
      expect(Permission.where(user: invite.invited_user,
                              resource: invite.campaign,
                              state: Permission.states[:translator],
                              locale: invite.locale)).to exist
    end
  end
end

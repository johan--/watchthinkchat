require 'rails_helper'

RSpec.describe Visitor::Invitee::Email, type: :model do
  subject(:email) { build(:invitee_email) }
  # validations
  it { is_expected.to validate_presence_of(:invitation) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:message) }
  describe 'validates invitee' do
    describe 'email' do
      context 'is present' do
        it 'is valid' do
          email.invitation.invitee.email = Faker::Internet.email
          is_expected.to be_valid
        end
      end
      context 'is not present' do
        it 'is invalid' do
          email.invitation.invitee.email = nil
          is_expected.to_not be_valid
        end
      end
    end
    describe 'first name' do
      context 'is present' do
        it 'is valid' do
          email.invitation.invitee.first_name = Faker::Name.first_name
          is_expected.to be_valid
        end
      end
      context 'is not present' do
        it 'is invalid' do
          email.invitation.invitee.first_name = nil
          is_expected.to_not be_valid
        end
      end
    end
  end
  describe 'validates inviter' do
    describe 'email' do
      context 'is present' do
        it 'is valid' do
          email.invitation.inviter.email = Faker::Internet.email
          is_expected.to be_valid
        end
      end
      context 'is not present' do
        it 'is invalid' do
          email.invitation.inviter.email = nil
          is_expected.to_not be_valid
        end
      end
    end
    describe 'first name' do
      context 'is present' do
        it 'is valid' do
          email.invitation.inviter.first_name = Faker::Name.first_name
          is_expected.to be_valid
        end
      end
      context 'is not present' do
        it 'is invalid' do
          email.invitation.inviter.first_name = nil
          is_expected.to_not be_valid
        end
      end
    end
  end

  # callbacks
  describe 'after_save' do
    it 'sends an email' do
      expect { email.save }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end

require 'spec_helper'

RSpec.describe User, type: :model do
  # associations
  it { is_expected.to have_many(:permissions).dependent(:destroy) }

  # validations
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_confirmation_of(:password).on(:create) }

  # definitions
  it '#name returns full name' do
    user = create(:user)
    expect(user.name).to eq("#{user.first_name} #{user.last_name}".strip)
  end
  describe '#as' do
    let(:user) { create(:user) }
    context ':manager' do
      context 'is manager' do
        it 'returns manager object' do
          user.roles << :manager
          expect(user.as(:manager)).to be_a(User::Manager)
        end
      end
      context 'is not manager' do
        it 'throws an exception' do
          expect { user.as(:manager) }
            .to raise_error(ActiveRecord::ActiveRecordError)
        end
      end
    end
    context ':translator' do
      context 'is translator' do
        it 'returns translator object' do
          user.roles << :translator
          expect(user.as(:translator)).to be_a(User::Translator)
        end
      end
      context 'is not translator' do
        it 'throws an exception' do
          expect { user.as(:translator) }
            .to raise_error(ActiveRecord::ActiveRecordError)
        end
      end
    end
    context ':visitor' do
      context 'is visitor' do
        it 'returns visitor object' do
          user.roles << :visitor
          expect(user.as(:visitor)).to be_a(User::Visitor)
        end
      end
      context 'is not visitor' do
        it 'throws an exception' do
          expect { user.as(:visitor) }
            .to raise_error(ActiveRecord::ActiveRecordError)
        end
      end
    end
  end
end

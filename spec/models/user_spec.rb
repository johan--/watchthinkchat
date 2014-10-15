require 'rails_helper'

RSpec.describe User, type: :model do
  # associations
  it { is_expected.to have_many(:permissions).dependent(:destroy) }
  it do
    is_expected.to have_many(:campaigns).through(:permissions)
                                        .source(:resource)
  end
  # definitions
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
  end
end

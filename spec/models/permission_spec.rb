require 'spec_helper'

RSpec.describe Permission, type: :model do
  it 'has a valid factory' do
    expect(create(:permission)).to be_valid
  end
  it 'is invalid without a resource' do
    expect(build(:permission, resource: nil)).not_to be_valid
  end
  it 'is invalid without a user' do
    expect(build(:permission, user: nil)).not_to be_valid
  end
  it 'is invalid without a state' do
    expect(build(:permission, state: nil)).not_to be_valid
  end
  it 'is destroyed when user is destroyed' do
    @permission = create(:permission)
    @permission.user.destroy!
    expect { @permission.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'is destroyed when resource is destroyed' do
    @permission = create(:permission)
    @permission.resource.destroy!
    expect { @permission.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end

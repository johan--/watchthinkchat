require 'spec_helper'

RSpec.describe User::DashboardUser, type: :model do
  it 'is an abstract class' do
    expect(User::DashboardUser.abstract_class).to eq(true)
  end
end

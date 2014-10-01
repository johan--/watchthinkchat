require 'spec_helper'

describe UserDecorator, type: :decorator do
  let(:user) { create(:user).decorate }

  it '#name returns full name' do
    expect(user.name).to eq("#{user.first_name} #{user.last_name}".strip)
  end
end

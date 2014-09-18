require 'spec_helper'

RSpec.describe User::Translator, type: :model do
  it do
    is_expected.to have_many(:campaigns).through(:permissions)
                                        .source(:resource)
  end
end

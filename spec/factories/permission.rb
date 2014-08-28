# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    user
    association :resource, factory: :campaign
    state 0
  end
end

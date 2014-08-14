FactoryGirl.define do
  factory :chat do
    association :operator, factory: :operator, operator: true, status: 'online'
    association :visitor, factory: :user
    association :campaign, factory: :campaign
  end
end

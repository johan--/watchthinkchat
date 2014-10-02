# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interaction, class: User::Visitor::Interaction do
    association :resource, factory: :campaign
    visitor
    campaign
    action 0
  end
end

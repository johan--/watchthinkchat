# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interaction, class: User::Visitor::Interaction do
    resource_id 1
    resource_type "MyString"
    visitor_id 1
    campaign_id 1
    action 1
    data "MyText"
  end
end

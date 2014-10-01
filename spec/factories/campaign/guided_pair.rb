# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guided_pair, class: Campaign::GuidedPair do
    campaign
    enabled true
    title 'MyString'
    description 'MyText'
  end
end

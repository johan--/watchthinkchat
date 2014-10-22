# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :share, class: Campaign::Share do
    campaign
    enabled true
    title 'MyString'
    description 'MyText'
  end
end

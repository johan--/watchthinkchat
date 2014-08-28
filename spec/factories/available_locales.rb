# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :available_locale do
    campaign
    locale
  end
end

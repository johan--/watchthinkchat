# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option do
    title Faker::Lorem.sentence
    question
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    survey
    title Faker::Lorem.sentence
    help_text Faker::Hacker.say_something_smart
    sequence :position, 0
  end
end

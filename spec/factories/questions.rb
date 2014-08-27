# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    survey
    title { Faker::Lorem.sentence }
    help_text { Faker::Hacker.say_something_smart }
    sequence :position, 0
    factory :question_with_options do
      after(:create) do |question|
        create_list(:option, 5, question: question)
      end
    end
  end
end
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option, class: Campaign::EngagementPlayer::Option do
    title Faker::Lorem.sentence
    question
  end
end

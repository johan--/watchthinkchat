FactoryGirl.define do
  factory :option, class: Campaign::EngagementPlayer::Option do
    title { Faker::Lorem.sentence }
    question
  end
end

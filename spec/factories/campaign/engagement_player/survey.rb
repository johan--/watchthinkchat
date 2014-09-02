# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey, class: Campaign::EngagementPlayer::Survey do
    engagement_player
  end
end

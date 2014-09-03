FactoryGirl.define do
  factory :survey, class: Campaign::EngagementPlayer::Survey do
    engagement_player
  end
end

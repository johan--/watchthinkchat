FactoryGirl.define do
  factory :survey, class: Campaign::EngagementPlayer::Survey do
    ignore do
      after(:build) do |survey|
        survey.engagement_player = build(:engagement_player, survey: survey)
      end
    end
    trait :no_engagement_player do
      after(:build) do |survey|
        survey.engagement_player = nil
      end
    end
  end
end

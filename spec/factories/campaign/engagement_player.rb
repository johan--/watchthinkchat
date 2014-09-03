FactoryGirl.define do
  factory :engagement_player, class: Campaign::EngagementPlayer do
    campaign
    media_link { Faker::Internet.url('youtube.com') }
  end
end

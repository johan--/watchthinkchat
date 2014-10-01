FactoryGirl.define do
  factory :engagement_player, class: Campaign::EngagementPlayer do
    campaign
    enabled true
    media_link { Faker::Internet.url('youtube.com') }
    media_start 0
    media_stop 150
  end
end

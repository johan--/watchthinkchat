require 'faker'

FactoryGirl.define do
  factory :engagement_player do
    campaign
    media_link { Faker::Internet.url('youtube.com') }
  end
end

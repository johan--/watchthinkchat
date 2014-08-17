require 'faker'

FactoryGirl.define do
  factory :engagement_player do |f|
    f.campaign { create(:campaign) }
    f.media_link { Faker::Internet.url('youtube.com') }
  end
end

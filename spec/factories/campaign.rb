FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |n| "campaign_#{n}" }
    sequence(:permalink) { |n| "permalink_#{n}" }
    missionhub_token 'missionhub_token'
    status 'opened'
    max_chats 2
    locale
  end
end

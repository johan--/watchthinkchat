FactoryGirl.define do
  factory :user, aliases: [:visitor, :operator] do
    sequence(:email) {|n| "user#{n}@example.com" }
  end

  factory :campaign do
    sequence(:name) {|n| "campaign_#{n}" }
    missionhub_secret "missionhub_secret"
  end
end

FactoryGirl.define do
  factory :user, aliases: [:visitor, :operator] do
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:first_name) {|n| "first_name_#{n}" }
  end

  factory :campaign do
    sequence(:name) {|n| "campaign_#{n}" }
    sequence(:permalink) {|n| "permalink_#{n}" }
    missionhub_secret "missionhub_secret"
  end
end

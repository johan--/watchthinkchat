FactoryGirl.define do
  factory :user, aliases: [:visitor, :operator] do
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:first_name) {|n| "first_name_#{n}" }
    sequence(:missionhub_id) {|n| n }
  end

  factory :campaign do
    sequence(:name) {|n| "campaign_#{n}" }
    sequence(:permalink) {|n| "permalink_#{n}" }
    missionhub_token "missionhub_token"
    status "opened"
  end

  factory :chat do
    association :operator, factory: :user, operator_uid: "op_uid", operator: true, status: "online"
    association :visitor, factory: :user
    association :campaign, factory: :campaign
  end
end

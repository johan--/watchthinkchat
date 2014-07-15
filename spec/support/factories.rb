FactoryGirl.define do
  factory :user, aliases: [:visitor] do
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:first_name) {|n| "first_name_#{n}" }
    sequence(:missionhub_id) {|n| n }
  end

  factory :operator, parent: :user do
    sequence(:operator_uid) {|n| "op_uid#{n}" }
    operator true
  end

  factory :campaign do
    sequence(:name) {|n| "campaign_#{n}" }
    sequence(:permalink) {|n| "permalink_#{n}" }
    missionhub_token "missionhub_token"
    status "opened"
    max_chats 2
  end

  factory :chat do
    association :operator, factory: :operator, operator: true, status: "online"
    association :visitor, factory: :user
    association :campaign, factory: :campaign
  end

  factory :user_operator
end

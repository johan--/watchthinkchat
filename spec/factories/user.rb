FactoryGirl.define do
  factory :user, aliases: [:visitor] do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:first_name) { |n| "first_name_#{n}" }
    sequence(:missionhub_id) { |n| n }
  end
end

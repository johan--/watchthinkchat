FactoryGirl.define do
  factory :community, class: Campaign::Community do
    campaign
    url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
    other_campaign false
    factory :community_other_campaign do
      other_campaign true
      association :child_campaign, factory: :campaign
    end
  end
end

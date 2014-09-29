FactoryGirl.define do
  factory :community, class: Campaign::Community do
    campaign
    enabled true
    other_campaign false
    title { Faker::Name.title }
    url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
    factory :community_other_campaign do
      other_campaign true
      association :child_campaign, factory: :campaign
      title nil
      url nil
      description nil
    end
    factory :community_disabled do
      enabled false
      other_campaign nil
      title nil
      url nil
      description nil
    end
  end
end

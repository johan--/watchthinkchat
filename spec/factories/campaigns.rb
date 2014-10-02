FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |n| "campaign_#{n}" }
    status Campaign.statuses[:opened]
    sequence(:url) { |n| "campaign-#{n}.#{Faker::Internet.domain_name}" }
    subdomain false
    locale
    factory :subdomain_campaign do
      sequence(:url) { |n| "campaign-#{n}#{Faker::Internet.domain_word}" }
      subdomain true
    end
  end
end

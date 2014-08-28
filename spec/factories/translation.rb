# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :translation do
    content { Faker::Lorem.sentence }
    association :resource, factory: :campaign
    field 'title'
    campaign
    locale
    base { false }
    factory :campaign_translation do
      association :resource, factory: :campaign
    end
    factory :question_translation do
      association :resource, factory: :question
    end
    factory :option_translation do
      association :resource, factory: :option
    end
    factory :engagement_player_translation do
      association :resource, factory: :engagement_player
    end
  end
end

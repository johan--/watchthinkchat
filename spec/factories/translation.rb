FactoryGirl.define do
  factory :translation do
    content { Faker::Lorem.sentence }
    association :resource, factory: :option
    field 'title'
    campaign
    base { true }
    factory :question_translation do
      association :resource, factory: :question
    end
    factory :option_translation do
      association :resource, factory: :option
    end
    factory :engagement_player_translation do
      association :resource, factory: :engagement_player
    end
    factory :locale_translation do
      locale
      base { false }
    end
  end
end

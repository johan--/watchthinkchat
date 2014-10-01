FactoryGirl.define do
  factory :option, class: Campaign::Survey::Question::Option do
    title { Faker::Lorem.sentence }
    question
  end
end

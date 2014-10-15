FactoryGirl.define do
  factory :locale do
    code { Faker::Hacker.abbreviation }
    name { Faker::Hacker.verb }
  end
end

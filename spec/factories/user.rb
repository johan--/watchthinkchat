FactoryGirl.define do
  factory :user, aliases: [:visitor] do
    sequence(:email) { |_n| Faker::Internet.email }
    sequence(:first_name) { |_n| Faker::Name.first_name }
  end
end

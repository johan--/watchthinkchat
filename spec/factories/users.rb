FactoryGirl.define do
  factory :user do
    sequence(:email) { |_n| Faker::Internet.email }
    sequence(:first_name) { |_n| Faker::Name.first_name }
    sequence(:last_name) { |_n| Faker::Name.last_name }
    password { SecureRandom.hex(3) }
  end
end

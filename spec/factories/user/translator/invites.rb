FactoryGirl.define do
  factory :invite, class: User::Translator::Invite do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    campaign
    locale
  end
end

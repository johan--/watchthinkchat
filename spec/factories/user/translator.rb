FactoryGirl.define do
  factory :translator, class: User::Manager do
    sequence(:email) { |_n| Faker::Internet.email }
    sequence(:first_name) { |_n| Faker::Name.first_name }
    after(:build) do |translator|
      translator.roles << :translator
    end
  end
end

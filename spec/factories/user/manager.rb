FactoryGirl.define do
  factory :manager, class: User::Manager do
    sequence(:email) { |_n| Faker::Internet.email }
    sequence(:first_name) { |_n| Faker::Name.first_name }
    after(:build) do |manager|
      manager.roles << :manager
    end
  end
end

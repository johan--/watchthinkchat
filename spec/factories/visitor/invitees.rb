FactoryGirl.define do
  factory :invitee, class: Visitor::Invitee do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    notify_inviter true
  end
end

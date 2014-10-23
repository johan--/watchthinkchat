FactoryGirl.define do
  factory :invitee_email, class: Visitor::Invitee::Email do
    skip_create
    subject { Faker::Lorem.sentence }
    message { Faker::Lorem.paragraph }
    invitation
  end
end

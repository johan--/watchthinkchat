# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation, class: Visitor::Invitation do
    invitee
    inviter
    campaign
  end
end

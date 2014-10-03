# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interaction, class: User::Visitor::Interaction do
    visitor
    campaign
    action 0
    after(:build) { |interaction| interaction.resource = interaction.campaign }
  end
end

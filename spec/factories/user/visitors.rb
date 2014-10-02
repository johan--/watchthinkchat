FactoryGirl.define do
  factory :visitor, class: User::Visitor do
    after(:build) do |visitor|
      visitor.roles << :visitor
    end
  end
end

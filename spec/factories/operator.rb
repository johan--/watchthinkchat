FactoryGirl.define do
  factory :operator, parent: :user do
    sequence(:operator_uid) { |n| "op_uid#{n}" }
    operator true
  end
end

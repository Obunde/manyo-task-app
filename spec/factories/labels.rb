FactoryBot.define do
  factory :label do
    name { "Work" }
    association :user
  end
end
FactoryBot.define do
  factory :user do
    name { "General User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    admin { false }

    trait :admin do
      admin { true }
    end

    factory :admin_user do
      name { "Admin User" }
      email { "admin@example.com" }
      admin { true }
    end
  end
end
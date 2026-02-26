FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "test@example.com" }
    password_digest { "password123" }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end

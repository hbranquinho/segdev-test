FactoryBot.define do
  factory :vehicle do
    year { Faker::Number.between(from: 1801, to: Time.now.year) }
    user
  end
end

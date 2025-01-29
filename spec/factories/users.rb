FactoryBot.define do
  factory :user do
    age { Faker::Number.between(from: 0, to: 100) }
    dependents { Faker::Number.between(from: 0, to: 5) }
    income { Faker::Number.between(from: 0, to: 500_000) }
    marital_status { %w[single married].sample }
    risk_questions { [ 0, 1, 0 ] } # Sempre um array de 3 valores entre 0 e 1
  end
end

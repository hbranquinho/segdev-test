FactoryBot.define do
  factory :house do
    ownership_status { %w[owned rented].sample }
    user
  end
end

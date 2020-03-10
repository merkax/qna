FactoryBot.define do
  factory :question do
    title {"My title"}
    body {"My body"}

    trait :invalid do
      title { nil }
    end
  end
end

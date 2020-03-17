FactoryBot.define do
  sequence(:title) { |n| "Title question #{n}" }
  sequence(:body) { |n| "Body question #{n}" }
  
  factory :question do
    title 
    body 
    user

    trait :invalid do
      title { nil }
      body { nil}
    end
  end
end

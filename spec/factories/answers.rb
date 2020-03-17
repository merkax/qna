FactoryBot.define do

  sequence(:answer_body) { |n| "My body answer #{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    user
    
    trait :invalid do
      body { nil }
    end
  end
end

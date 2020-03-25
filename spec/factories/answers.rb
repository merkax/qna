FactoryBot.define do

  sequence(:answer_body) { |n| "My body answer #{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    user
    
    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        file1 = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb') 
        file2 = fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'spec_helper/rb') 
        answer.files.attach(file1, file2)
      end
    end
  end
end

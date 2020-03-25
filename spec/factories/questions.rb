FactoryBot.define do
  sequence(:title) { |n| "Title question #{n}" }
  sequence(:body) { |n| "Body question #{n}" }
  
  factory :question do
    title 
    body 
    user

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      after :create do |question|
        file1 = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb') 
        file2 = fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'spec_helper/rb') 
        question.files.attach(file1, file2)
      end
    end
  end
end

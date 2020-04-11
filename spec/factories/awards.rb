FactoryBot.define do
  factory :award do
    name { "MyName" }
    question
    user { nil }

    trait :with_image do
      image { fixture_file_upload("#{Rails.root}/app/assets/images/award.png") }
    end
  end
end

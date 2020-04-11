FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { 'https://www.google.com/' }
    linkable { nil }

    
    trait :invalid_url do
      url { 'invalid_url' }
    end

    trait :gist_valid_url do
      url { 'https://gist.github.com/merkax/7888a37c76e5a69b0de1dda0ee5f326b' }
    end

    trait :gist_invalid_url do
      url { 'https://www.google.com/' }
    end
  end
end

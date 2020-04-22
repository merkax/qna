FactoryBot.define do
  factory :comment do
    body { "My comment" }
    user
    commentable { nil}

    trait 'invalid' do
      body { nil }
    end
  end
end

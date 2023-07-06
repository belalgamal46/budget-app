FactoryBot.define do
  factory :trade do
    name { 'MyString' }
    amount { 1 }
    author_id { nil }
  end
end

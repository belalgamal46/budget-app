FactoryBot.define do
  factory :trade do
    name { "MacDonald's" }
    amount { 1 }
    user_id { association(:user) }
  end
end

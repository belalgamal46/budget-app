FactoryBot.define do
  factory :group do
    name { 'Food' }
    icon { 'https://images.pexels.com/photos/16963896/pexels-photo-16963896/free-photo-of-celery-juice.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load' }
    user_id { association(:user) }
  end
end

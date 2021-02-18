FactoryBot.define do
  factory :user do
    name { 'Dileep' }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
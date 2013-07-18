FactoryGirl.define do
  sequence(:email) do |n|
    "email#{n}@email.com"
  end

  factory :user do
    name                  "An user"
    email
    password              '123456'
    password_confirmation '123456'
  end
end
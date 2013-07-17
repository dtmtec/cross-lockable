FactoryGirl.define do
  factory :user do
    name                  "An user"
    email                 "email@email.com"
    password              '123456'
    password_confirmation '123456'
  end
end
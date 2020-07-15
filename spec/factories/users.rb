FactoryBot.define do
  factory :user do
    sequence :name do |n|
      "Good user #{n}"
    end
    sequence :email do |n|
      "alexhaas#{n}@test.com"
    end
    password {"alexhaastesting"}
  end
end

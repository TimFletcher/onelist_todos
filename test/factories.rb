FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'secret'
    password_confirmation 'secret'
  end

  factory :list do
    sequence :name do |n|
      "List Name #{n}"
    end
    user # Automatically builds a user from factory definition above
  end

  factory :list_item do
    sequence :text do |n|
      "List item text #{n}"
    end
    complete false
    list
  end
end


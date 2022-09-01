FactoryBot.define do
  factory :item do
    name { Faker::Dessert.variety }
    description { Faker::Dessert.flavor }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end

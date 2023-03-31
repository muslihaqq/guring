# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    handle { Faker::Internet.username(specifier: 5..10) }
  end
end
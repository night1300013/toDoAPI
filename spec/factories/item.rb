require 'random_data'

FactoryBot.define do
  factory :item do
    body RandomData.random_sentence
    list
    completed false
  end
end

require 'random_data'

FactoryBot.define do
  factory :list do
    title RandomData.random_sentence
    private false
    user
  end
end

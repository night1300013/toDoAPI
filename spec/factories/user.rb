require 'random_data'

FactoryBot.define do
  pw = RandomData.random_sentence

  factory :user do
    sequence(:email){|n| "user#{n}@factory.com" }
    password pw
    password_confirmation pw
    auth_token SecureRandom.hex
    token_created_at Time.zone.now
  end
end

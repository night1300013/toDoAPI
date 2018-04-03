class List < ApplicationRecord
  belongs_to :user
  has_many :items
  validates :title, :user_id, presence: true
end

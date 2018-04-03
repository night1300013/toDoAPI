class Item < ApplicationRecord
  belongs_to :list
  validates :body, :list_id, presence: true
end

class Item < ApplicationRecord
  belongs_to :list
  validates :body, :list_id, :completed, presence: true
end

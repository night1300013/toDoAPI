class ItemSerializer < ActiveModel::Serializer
  attributes :id, :body, :list_id, :completed
end

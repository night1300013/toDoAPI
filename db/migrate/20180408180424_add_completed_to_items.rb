class AddCompletedToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :completed, :boolean
  end
end

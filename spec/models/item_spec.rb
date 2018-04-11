require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let(:item) { create(:item, list: list)}

  it { is_expected.to belong_to(:list) }
  it { is_expected.to validate_presence_of(:body)}

  describe "attributes" do
    it "has body, completed, and list" do
      expect(item).to have_attributes(body: item.body, completed: item.completed, list: list)
    end

    it "is not completed by default" do
      expect(item.completed).to be(false)
    end
  end
end

require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:items).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:title)}

  describe "attributes" do
    it "has title, private, and user" do
      expect(list).to have_attributes(title: list.title, private: list.private, user: user)
    end

    it "is not private by default" do
      expect(list.private).to be(false)
    end
  end
end

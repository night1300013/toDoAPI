require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user)}

  it { is_expected.to have_many(:lists) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do
    it "should have email attribute" do
      expect(user).to have_attributes(email: user.email)
    end

    it "should have password attribute" do
      expect(user).to have_attributes(password: user.password)
    end

    it "should have password_confirmation attribute and the same as password" do
      expect(user).to have_attributes(password_confirmation: user.password)
    end
  end

  describe "when email is not present" do
    let(:user_with_invalid_email) { build(:user, email: "") }

    it "should be invalid due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end
  end
end

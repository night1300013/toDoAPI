require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let!(:users) { create_list(:user, 10)}
  let(:user1) { users.first }
  let(:user2) { users.second }

  describe "GET index" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "returns the information about a reporter on a hash" do
      get :index
      user_response = JSON.parse(response.body, symbolize_names: true)
      #binding.pry
      expect(user_response[0][:email]).to eq user1.email
    end

    it "returns 10 users" do
      get :index
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response.size).to eq 10
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    it "returns http success" do
      post :create, params: { user: { email: "123@123.com", password: "123456", password_confirmation: "123456"}}
      expect(response).to have_http_status(200)
    end

    it "increases the number of user by 1" do
      expect {post :create, params: { user: { email: "123@123.com", password: "123456", \
        password_confirmation: "123456"}}}.to change(User, :count).by(1)
    end

    it "adds user successfully" do
      post :create, params: { user: { email: "123@123.com", password: "123456", password_confirmation: "123456"}}
      expect(User.last.email).to eq "123@123.com"
    end
  end

  describe "DELETE destroy" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "can delete itself" do
      delete :destroy, params: { id: user1.id }
      count = User.where({id: user1.id}).size
      expect(count).to eq 0
    end

    it "cannot delete other user" do
      delete :destroy, params: { id: user2.id }
      count = User.where({id: user2.id}).size
      expect(count).to eq 1
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT update" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end
    it "returns http success" do
      new_email = RandomData.random_email

      put :update, params: { id: user1.id, user: { email: new_email } }
      expect(response).to have_http_status(200)
    end

    it "updates user with expected attributes" do
      new_email = RandomData.random_email
      new_password = RandomData.random_sentence

      put :update, params: { id: user1.id, user: { email: new_email, \
        password: new_password, password_confirmation: new_password } }

      user_response = JSON.parse(response.body, symbolize_names: true)

      expect(user_response[:id]).to eq user1.id
      expect(user_response[:email]).to eq new_email
    end

    it "cannot update other user's attributes" do
      new_email = RandomData.random_email
      new_password = RandomData.random_sentence

      put :update, params: { id: user2.id, user: { email: new_email, \
        password: new_password, password_confirmation: new_password } }

      expect(response).to have_http_status(401)
    end
  end
end

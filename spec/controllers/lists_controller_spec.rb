require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:lists) { create_list(:list,10, user: user1) }
  let(:list1) { lists.first}
  let!(:list2) { create(:list, user: user2) }

  describe "GET index" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "returns the information about a reporter on a hash" do
      get :index
      list_response = JSON.parse(response.body, symbolize_names: true)
#      binding.pry
      expect(list_response[0][:title]).to eq list1.title
    end

    it "returns 11 lists" do
      get :index
      list_response = JSON.parse(response.body, symbolize_names: true)
      expect(list_response.size).to eq 11
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "returns http success" do
      post :create, params: { list: { title: RandomData.random_sentence, user: user1}}
      expect(response).to have_http_status(200)
    end

    it "increases the number of list by 1" do
      expect { post :create, params: { list: { title: RandomData.random_sentence,\
         user: user1}}}.to change(List, :count).by(1)
    end

    it "adds list successfully" do
      title = RandomData.random_sentence
      post :create, params: { list: { title: title, user: user1}}
      expect(List.last.title).to eq title
    end
  end

  describe "DELETE destroy" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "can delete user1's list" do
      delete :destroy, params: { user_id: user1.id, id: list1.id }
      count = List.where({id: list1.id}).size
      expect(count).to eq 0
    end

    it "cannot delete other user's list" do
      delete :destroy, params: { user_id: user2.id, id: list2.id }
      count = List.where({id: list2.id}).size
      expect(count).to eq 1
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT update" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end
    it "returns http success" do
      new_title = RandomData.random_sentence

      put :update, params: { user_id: user1.id, id: list1.id, list: { title: new_title } }
      expect(response).to have_http_status(200)
    end

    it "updates user with expected attributes" do
      new_title = RandomData.random_sentence

      put :update, params: { user_id: user1.id, id: list1.id, list: { title: new_title} }

      list_response = JSON.parse(response.body, symbolize_names: true)

      expect(list_response[:id]).to eq list1.id
      expect(list_response[:title]).to eq new_title
    end

    it "cannot update other user's list" do
      new_title = RandomData.random_sentence

      put :update, params: { user_id: user2.id, id: list2.id, list: { title: new_title} }

      expect(response).to have_http_status(401)
    end
  end
end

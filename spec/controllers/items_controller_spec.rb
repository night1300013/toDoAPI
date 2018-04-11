require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:lists) { create_list(:list, 10, user: user1) }
  let(:list1) { lists.first }
  let!(:list2) { create(:list, user: user2) }
  let!(:items) { create_list(:item, 10, list: list1 ) }
  let(:item1) { items.first }
  let!(:item2) { create(:item, list: list2) }

  describe "GET index" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "returns the information about a reporter on a hash" do
      get :index
      item_response = JSON.parse(response.body, symbolize_names: true)
#      binding.pry
      expect(item_response[0][:body]).to eq item1.body
    end

    it "returns 11 items" do
      get :index
      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response.size).to eq 11
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
      post :create, params: { list_id: list1.id, item: { body: RandomData.random_sentence}}
      expect(response).to have_http_status(200)
    end

    it "increases the number of item by 1" do
      expect { post :create, params: { list_id: list1.id, \
        item: { body: RandomData.random_sentence}}}.to change(Item, :count).by(1)
    end

    it "adds item successfully" do
      body = RandomData.random_sentence
      post :create, params: { list_id: list1.id, item: { body: body, completed: false}}
      expect(Item.last.body).to eq body
      expect(Item.last.completed).to eq false
    end

    it "cannot create item on other user's list" do
      post :create, params: { list_id: list2.id, item: { body: RandomData.random_sentence}}

      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE destroy" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end

    it "can delete list1's item" do
      delete :destroy, params: { list_id: list1.id, id: item1.id }
      count = Item.where({id: item1.id}).size
      expect(count).to eq 0
    end

    it "cannot delete other user's list's item" do
      delete :destroy, params: { list_id: list2.id, id: item2.id }
      count = Item.where({id: item2.id}).size
      expect(count).to eq 1
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT update" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = "Token token=#{user1.auth_token}"
    end
    it "returns http success" do
      new_body = RandomData.random_sentence

      put :update, params: { list_id: list1.id, id: item1.id, item: { body: new_body } }
      expect(response).to have_http_status(200)
    end

    it "updates user with expected attributes" do
      new_body = RandomData.random_sentence
      
      put :update, params: { list_id: list1.id, id: item1.id, item: { body  : new_body} }

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:id]).to eq item1.id
      expect(item_response[:body]).to eq new_body
    end

    it "cannot update other user's list" do
      new_body = RandomData.random_sentence

      put :update, params: { list_id: list2.id, id: item2.id, item: { body: new_body} }

      expect(response).to have_http_status(401)
    end
  end
end

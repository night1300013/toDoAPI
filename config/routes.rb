Rails.application.routes.draw do
  #devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    as :user do
      post   "/sign-in"  => "sessions#create"
      delete "/sign-out" => "sessions#destroy"
    end

    resources :users, only: [:index, :create, :update, :destroy] do
      resources :lists, only: [:update, :destroy]
    end

    resources :lists, only: [:index, :create]

    resources :lists, only: [] do
      resources :items, only: [:create, :update, :destroy]
    end

    resources :items, only: [:index]
  end
end

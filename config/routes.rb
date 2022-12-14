Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find_all", to: "merchants#find_all"
      get "/merchants/find", to: "merchants#find"
      get "/items/find", to: "items#find"
      get "/items/find_all", to: "items#find_all"

      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchant_items#index"
      end

      resources :items, only: [:index, :show, :create, :destroy, :update] do
        get "/merchant", to: "item_merchant#show"
      end
    end
  end
end

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find_all", to: "merchants#find_all"
      get "/items/find", to: "items#find"

      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchant_items#index"
      end
      
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        get "/merchant", to: "item_merchant#show"
      end
    end
  end
end

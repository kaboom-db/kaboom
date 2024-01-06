Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  root "pages#index"

  resources :comics, only: [:index, :show] do
    resources :issues, only: [:index, :show] do
      post :read, on: :member
      post :unread, on: :member
      post :wishlist, on: :member
      post :unwishlist, on: :member
      post :favourite, on: :member
      post :unfavourite, on: :member
      post :collect, on: :member
      post :uncollect, on: :member
    end

    post :import, on: :collection

    post :wishlist, on: :member
    post :unwishlist, on: :member
    post :favourite, on: :member
    post :unfavourite, on: :member
  end

  resources :users, only: [:show] do
    resources :statistics, only: [:index, :show]
  end

  get "dashboard" => "dashboard#index"
  get "dashboard/history" => "dashboard#history"
  get "dashboard/collection" => "dashboard#collection"
end

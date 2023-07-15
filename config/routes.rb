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
    end

    post :import, on: :collection
  end

  get "dashboard" => "dashboard#index"
  get "dashboard/history" => "dashboard#history"
end

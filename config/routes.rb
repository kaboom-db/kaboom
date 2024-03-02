Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  root "pages#index"

  get "privacy_policy" => "pages#privacy"
  get "sitemap" => "pages#sitemap", :as => "sitemap", :format => "xml"

  resources :comics, only: [:index, :show, :edit, :update] do
    resources :issues, only: [:index, :show, :edit, :update] do
      post :read, on: :member
      post :unread, on: :member
      post :wishlist, on: :member
      post :unwishlist, on: :member
      post :favourite, on: :member
      post :unfavourite, on: :member
      post :collect, on: :member
      post :uncollect, on: :member
    end

    collection do
      resources :genres, only: [:show]

      post :import
    end

    member do
      post :wishlist
      post :unwishlist
      post :favourite
      post :unfavourite
      post :read_range
      post :refresh
      post :read_next_issue
    end
  end

  resources :users, only: [:show, :edit, :update] do
    resources :statistics, only: [:index, :show]

    get :history, on: :member
    get :deck, on: :member
    get :favourites, on: :member
    get :completed, on: :member
    get :collection, on: :member
    get :wishlist, on: :member
  end

  resources :site_statistics, only: [:index]

  get "dashboard" => "dashboard#index"
  get "dashboard/history" => "dashboard#history"
  get "dashboard/collection" => "dashboard#collection"
end

Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  root "pages#index"

  get "privacy_policy" => "pages#privacy"
  get "sitemap" => "pages#sitemap", :as => "sitemap", :format => "xml"

  resources :search, only: [:index]

  resources :comics, only: [:index, :show, :edit, :update] do
    resources :issues, only: [:index, :show, :edit, :update] do
      member do
        post :read
        post :unread
        post :wishlist
        post :unwishlist
        post :favourite
        post :unfavourite
        post :collect
        post :uncollect
        post :refresh
      end
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
      post :hide
    end
  end

  resources :users, only: [:show, :edit, :update] do
    resources :statistics, only: [:index, :show]

    member do
      get :history
      get :deck
      get :favourites
      get :completed
      get :collection
      get :wishlist
      get :load_more_activities
      get :load_more_followers
      get :load_more_following

      post :follow
      post :unfollow
    end
  end

  resources :collected_issues, only: [:update]
  resources :site_statistics, only: [:index]

  get "dashboard" => "dashboard#index"
  get "dashboard/history" => "dashboard#history"
  get "dashboard/collection" => "dashboard#collection"
  get "dashboard/load_more_activities" => "dashboard#load_more_activities"

  unless Rails.application.config.consider_all_requests_local
    get "*path", to: "application#not_found", via: :all
  end
end

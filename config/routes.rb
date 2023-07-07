Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  root "pages#index"
  get "dashboard" => "pages#dashboard"

  resources :comics, only: [:index, :show] do
    resources :issues, only: [:index, :show] do
      post :read, on: :member
    end

    post :import, on: :collection
  end
end

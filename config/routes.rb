Rails.application.routes.draw do
  devise_for :users

  root "pages#index"
  get "dashboard" => "pages#dashboard"

  resources :comics, only: [:index, :show] do
    resources :issues, only: [:index, :show]

    post :import, on: :collection
  end
end

Rails.application.routes.draw do
  devise_for :users

  root "pages#index"
  get "dashboard" => "pages#dashboard"
end

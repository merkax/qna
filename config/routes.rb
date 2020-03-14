Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, only: [:show, :new, :create], shallow: true
  end
end

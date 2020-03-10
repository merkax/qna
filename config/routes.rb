Rails.application.routes.draw do
  resources :questions do
    resources :answers, only: [:show, :new, :create], shallow: true
  end
end

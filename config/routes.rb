Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"


  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :set_best, on: :member
    end
  end
  
  resources :awards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
end

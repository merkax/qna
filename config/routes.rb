Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"


  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :set_best, on: :member
    end
  end
  
  resources :awards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end

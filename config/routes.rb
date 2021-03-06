require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
                                    confirmations: 'confirmations' }
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
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end
  
  resources :awards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :search, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end

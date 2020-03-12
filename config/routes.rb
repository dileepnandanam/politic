Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  root to: "posts#index"
  get 'dashboard', to: 'home#dashboard'
  get 'accepted_responses', to: 'home#accepted_responses'
  get 'responses', to: 'home#responses'
  get 'questions', to: 'home#questions'
  get 'terms_of_use', to: 'home#terms_of_use'
  get 'privacy_policy', to: 'home#privacy_policy'
  patch 'set_gender', to: 'home#set_gender'
  get 'signin-facebook', to: 'users/omniauth_callbacks#facebook'
  get 'access_restricted', to: 'home#access_restricted'

  resources :posts, controller: 'posts' do
    get :preview, on: :member
    put :upvote, on: :member
    put :downvote, on: :member
    resources :comments, controller: 'posts/comments' do
      put :upvote, on: :member
      put :downvote, on: :member
    end
  end
  resources :users do
    post :signin, on: :collection
    get :switch, on: :member
    get :posts, on: :member
    put :disconnect, on: :member
    get :notifications, on: :member
    get :connections, on: :collection
    resources :responses do
      put :accept, on: :member
    end
    resources :posts
  end

  resources :chats do
    put :seen, on: :member
  end

  resources :questions do
  	put :reorder, on: :collection
  end

  resources :groups do
    get :dashboard, on: :member
    get :responses, on: :member
    get :search, on: :collection
    resources :responses, controller: 'groups/responses' do
      put :accept, on: :member
    end
    resources :questions, controller: 'groups/questions' do
      put :reorder, on: :collection
    end
    resources :posts, controller: 'groups/posts' do
      put :upvote, on: :member
      put :downvote, on: :member
      resources :comments, controller: 'groups/posts/comments' do
        put :upvote, on: :member
        put :downvote, on: :member
      end
    end
  end
  resources :surveys do
    get :search, on: :collection
    get :dashboard, on: :member
    get :responses, on: :member
    resources :questions, controller: 'surveys/questions'
    resources :survey_responses, controller: 'surveys/survey_responses'
  end

  resources :quick_polls do
    get :search, on: :collection
    get :dashboard, on: :member
    resources :questions, controller: 'quick_polls/questions'
    resources :quick_poll_responses, controller: 'quick_polls/quick_poll_responses'
  end

  resources :affiliations
  get '/:permalink', to: 'home#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

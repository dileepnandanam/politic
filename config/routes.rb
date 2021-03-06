Rails.application.routes.draw do
  resources :photos
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  root to: "posts#index"
  get 'how_to_use', to: 'home#how_to_use'
  get 'example', to: 'home#example'
  get 'configuration', to: 'home#configuration'
  put 'update_configuration', to: 'home#update_configuration'
  get 'dashboard', to: 'home#dashboard'
  get 'accepted_responses', to: 'home#accepted_responses'
  get 'responses', to: 'home#responses'
  get 'questions', to: 'home#questions'
  get 'terms_of_use', to: 'home#terms_of_use'
  get 'privacy_policy', to: 'home#privacy_policy'
  patch 'set_gender', to: 'home#set_gender'
  get 'signin-facebook', to: 'users/omniauth_callbacks#facebook'
  get 'access_restricted', to: 'home#access_restricted'
  get 'sitemap', to: 'home#sitemap'

  resource :otp do
    get :confirm, on: :member
  end
  resource :platform do
    get :users, on: :collection
  end
  resources :videos
  resources :notifications
  resources :galeries
  resources :pictures, controller: 'pictures' do
    put :select_survey, on: :member
    put :select_post, on: :member
    delete :delete_image, on: :member
  end
  
  resources :posts, controller: 'posts', scope: '/' do
    get :search_suggestions, on: :collection
    put :hide, on: :member
    put :unhide, on: :member
    get :boo, on: :collection
    put :update_urls, on: :member
    get :my_posts, on: :collection
    put :locate, on: :member
    put :vanish, on: :member
    get :preview, on: :member
    put :upvote, on: :member
    put :downvote, on: :member
    put :select_survey, on: :member
    put :select_quick_poll, on: :member
    put :select_project, on: :member
    put :pin, on: :member
    put :unpin, on: :member
    put :reorder_components, on: :member
    resources :comments, controller: 'posts/comments' do
      put :upvote, on: :member
      put :downvote, on: :member
    end
    put :change_style, on: :member
  end
  resources :users do
    put :sms_password, on: :collection
    put :locate, on: :collection
    put :vanish, on: :collection
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
    get :my_groups, on: :collection
    put :reorder_options, on: :collection
    get :dashboard, on: :member
    get :responses, on: :member
    get :search, on: :collection
    resources :group_responses, controller: 'groups/group_responses' do
      put :accept, on: :member
    end
    resources :users, controller: 'groups/users' do
      get :search, on: :collection
      get :show_chats, on: :member
    end
    resources :questions, controller: 'groups/questions' do
      put :reorder, on: :collection
      resources :options, controller: 'groups/questions/options'
    end
    resources :posts, controller: 'groups/posts' do
      put :reorder, on: :collection
      put :upvote, on: :member
      put :downvote, on: :member
      put :pin, on: :member
      put :unpin, on: :member
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
    resources :questions, controller: 'surveys/questions' do
      put :reorder, on: :collection
      resources :options, controller: 'surveys/questions/options'
    end
    resources :survey_responses, controller: 'surveys/survey_responses' do
      put :accept, on: :member
      put :reject, on: :member
      get :copy, on: :member
      post :paste, on: :member
    end
  end

  resources :quick_polls do
    get :search, on: :collection
    get :dashboard, on: :member
    put :reorder, on: :collection
    resources :questions, controller: 'quick_polls/questions'
    resources :quick_poll_responses, controller: 'quick_polls/quick_poll_responses'
  end

  resources :phones

  resources :affiliations
  get '/:id', to: 'posts#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

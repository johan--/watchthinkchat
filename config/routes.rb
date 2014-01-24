Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  get '/users/sign_up', to: redirect('/')
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
     delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
     get 'sign_out', :to => 'devise/sessions#destroy' # so that we can just put /sign_out in the url
  end

  authenticated :user do
    get 'me', to: "operators#index", as: :operator_dashboard
  end

  root 'site#index'

  get '/templates/:path.html' => 'templates#public_template', :constraints => { :path => /tour|features/  }
  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
  get ':path' => 'templates#index'
  get ':path/:subpath' => 'templates#index'

  # API
  get "/api/campaigns/:uid", to: "api/campaigns#show"
  post "/api/visitors", to: "api/visitors#create"
  post "/api/operators", to: "api/operators#create"
  get "/api/operators/:uid", to: "api/operators#show"
  post "/api/chats", to: "api/chats#create"
  post "/api/chats/:chat_uid/messages", to: "api/messages#create"
  get "/api/chats/:uid", to: "api/chats#show"

end

Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
     delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticated :user do
    get 'me', to: "operators#index", as: :operator_dashboard
  end

  root 'site#index'

  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
  #get ':path' => 'templates#index'
  #get ':path/:subpath' => 'templates#index'

  # API
  get "/api/campaigns/:uid", to: "api/campaigns#show"
  post "/api/visitors", to: "api/visitors#create"
  post "/api/operators", to: "api/operators#create"
  post "/api/chats", to: "api/chats#create"
  post "/api/chats/:chat_uid/messages", to: "api/messages#index"
  get "/api/chats/:uid", to: "api/chats#show"

end

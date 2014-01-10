require 'constraints/domain_constraint'
Godchat::Application.routes.draw do
  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
     delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticated :user do
    get 'me', to: "operators#index", as: :operator_dashboard
  end

  constraints Constraints::DomainConstraint.new(ENV['operator_app_url']) do
    root to: "site#index"
    get '/tour', to: "site#tour", as: :tour
    get '/features', to: "site#features", as: :features
    post '/pusher/presence' => 'pusher#presence'
    get '/find_friends' => 'friends#find'
    #get '/c/:channel', action: 'index', controller: 'operators', as: :channel_conversation
    get '/:campaign_id', to: "site#index" # angular will handle the correct view
  end

  get '/o/:code', to: "visitors#index"
  root to: "visitors#index", as: :campaign_root

  # API
  get "/api/campaigns/:uid", to: "api/campaigns#show"
  post "/api/visitors", to: "api/users#create", role: :visitor
  post "/api/operators", to: "api/users#create", role: :operator
  post "/api/chats", to: "api/chats#create"
  post "/api/chats/:chat_uid/messages", to: "api/messages#index"
  get "/api/chats/:uid", to: "api/chats#show"

end

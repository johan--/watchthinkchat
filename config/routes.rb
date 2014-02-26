Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  get '/users/sign_up', to: redirect('/')
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
     delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
     get 'sign_out', :to => 'devise/sessions#destroy' # so that we can just put /sign_out in the url
  end

  root 'site#index'

  get '/operator/:operator_uid' => 'operators#show'
  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
  get ':path' => 'templates#index'
  get ':path/:subpath' => 'templates#index'

  # API
  get  "/api/campaigns/:uid", to: "api/campaigns#show"
  post "/api/campaigns/:uid/password", to: "api/campaigns#password"
  post "/api/visitors", to: "api/visitors#create"
  put "/api/visitors/:uid", to: "api/visitors#update"
  post "/api/operators", to: "api/operators#create"
  get  "/api/operators/:uid", to: "api/operators#show"
  post "/api/chats", to: "api/chats#create"
  post "/api/chats/:chat_uid/messages", to: "api/messages#create"
  post "/api/chats/:uid/collect_stats", to: "api/chats#collect_stats"
  get  "/api/chats/:uid", to: "api/chats#show"
  delete "/api/chats/:uid", to: "api/chats#destroy"
  post "/api/emails", to: "api/emails#create"

  # Pusher
  post "/pusher/existence"
  post "/pusher/presence"
end

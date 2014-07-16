Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  get '/users/sign_up', to: redirect('/')
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
     delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
     get 'sign_out', :to => 'devise/sessions#destroy' # so that we can just put /sign_out in the url
  end

  root 'site#index'

  namespace "api" do
    resources :campaigns, param: :uid do
      member do
        post :password
        get :stats
      end
    end
  end

  get '/s/:uid' => 'url_fwds#show', :constraints => { :uid => /[0-9a-zA-Z]*/ }, :as => :url_fwd
  get '/manage' => 'manage#index'
  get '/manage/:a' => 'manage#index'
  get '/operator/:operator_uid' => 'operators#show'
  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
  get ':path' => 'templates#index'
  get ':path/:subpath' => 'templates#index'

  # API
=begin
  get  "/api/campaigns", to: "api/campaigns#index"
  post "/api/campaigns", to: "api/campaigns#create"
  get  "/api/campaigns/:uid", to: "api/campaigns#show"
  put  "/api/campaigns/:uid", to: "api/campaigns#update"
  post "/api/campaigns/:uid/password", to: "api/campaigns#password"
=end
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
  post "/api/url_fwds", to: "api/url_fwds#create"

  # Pusher
  post "/pusher/existence"
  post "/pusher/presence"
end

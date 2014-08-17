Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  constraints DomainConstraint.new(ENV['dashboard_url']) do
    devise_for :users,
               controllers: { registrations: 'registrations',
                              omniauth_callbacks: 'users/omniauth_callbacks' }

    authenticated :user do
      scope module: 'dashboard' do
        root to: 'index#index', as: :authenticated_root
        resources :campaigns do
          resources :build, controller: 'campaigns/build'
        end
      end
    end
    root to: redirect('users/sign_in')
  end

  namespace 'api' do
    resources :campaigns, param: :uid do
      member do
        post :password
        get :stats
      end
    end
  end

  get '/s/:uid' => 'url_fwds#show',
      constraints: { uid: /[0-9a-zA-Z]*/ },
      as: :url_fwd

  get '/operator/:operator_uid' => 'operators#show'
  get '/templates/:path.html' => 'templates#template',
      constraints: { path: /.+/ }
  get ':path' => 'templates#index'
  get ':path/:subpath' => 'templates#index'

  # API
  # get  '/api/campaigns', to: 'api/campaigns#index'
  # post '/api/campaigns', to: 'api/campaigns#create'
  # get  '/api/campaigns/:uid', to: 'api/campaigns#show'
  # put  '/api/campaigns/:uid', to: 'api/campaigns#update'
  # post '/api/campaigns/:uid/password', to: 'api/campaigns#password'

  post '/api/visitors', to: 'api/visitors#create'
  put '/api/visitors/:uid', to: 'api/visitors#update'
  post '/api/operators', to: 'api/operators#create'
  get '/api/operators/:uid', to: 'api/operators#show'
  post '/api/chats', to: 'api/chats#create'
  post '/api/chats/:chat_uid/messages', to: 'api/messages#create'
  post '/api/chats/:uid/collect_stats', to: 'api/chats#collect_stats'
  get '/api/chats/:uid', to: 'api/chats#show'
  delete '/api/chats/:uid', to: 'api/chats#destroy'
  post '/api/emails', to: 'api/emails#create'
  post '/api/url_fwds', to: 'api/url_fwds#create'

  # Pusher
  post '/pusher/existence'
  post '/pusher/presence'
end

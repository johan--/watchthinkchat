Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  constraints DomainConstraint.new(ENV['dashboard_url']) do
    devise_for :users,
               controllers: { registrations: 'registrations',
                              omniauth_callbacks: 'users/omniauth_callbacks' }

    authenticated :user do
      root to: 'dashboard#index', as: :authenticated_root
      scope module: 'dashboard' do
        resources :campaigns do
          resources :build, controller: 'campaigns/build' do
            collection do
              namespace :api, defaults: { format: :json } do
                resources :questions do
                  resources :options
                end
              end
            end
          end
        end
      end
    end
    root to: redirect('users/sign_in'), as: :unauthenticated_root
  end

  namespace 'api' do
    post 'visitors', to: 'visitors#create'
    put 'visitors/:uid', to: 'visitors#update'
    post 'operators', to: 'operators#create'
    get 'operators/:uid', to: 'operators#show'
    post 'chats', to: 'chats#create'
    post 'chats/:chat_uid/messages', to: 'messages#create'
    post 'chats/:uid/collect_stats', to: 'chats#collect_stats'
    get 'chats/:uid', to: 'chats#show'
    delete 'chats/:uid', to: 'chats#destroy'
    post 'emails', to: 'emails#create'
    post 'url_fwds', to: 'url_fwds#create'
  end

  # get '/s/:uid' => 'url_fwds#show',
  #     constraints: { uid: /[0-9a-zA-Z]*/ },
  #     as: :url_fwd

  # get '/operator/:operator_uid' => 'operators#show'
  # get '/templates/:path.html' => 'templates#template',
  #     constraints: { path: /.+/ }
  # get ':path' => 'templates#index'
  # get ':path/:subpath' => 'templates#index'

  # API
  # get  '/api/campaigns', to: 'api/campaigns#index'
  # post '/api/campaigns', to: 'api/campaigns#create'
  # get  '/api/campaigns/:uid', to: 'api/campaigns#show'
  # put  '/api/campaigns/:uid', to: 'api/campaigns#update'
  # post '/api/campaigns/:uid/password', to: 'api/campaigns#password'

  # Pusher
  post '/pusher/existence'
  post '/pusher/presence'

  get '*path', to: 'site#index'
  root 'site#index'
end

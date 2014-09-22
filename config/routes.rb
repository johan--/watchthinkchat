Godchat::Application.routes.draw do
  ActiveAdmin.routes(self)

  constraints DomainConstraint.new("app.#{ENV['base_url']}") do
    devise_for :users,
               controllers: { registrations: 'registrations',
                              omniauth_callbacks: 'users/omniauth_callbacks' }
    authenticated :user do
      root to: 'dashboard#index', as: :authenticated_root
      scope module: 'dashboard' do
        resources :campaigns, only: [:index, :new, :show, :destroy] do
          resources :invites, module: 'campaigns', as: :user_translator_invites
          resources :permissions, only: [:destroy], module: 'campaigns'
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
        namespace :api, defaults: { format: :json } do
          get 'campaigns/:campaign_id/locales/:locale_id/translations/:id',
              to: 'translations#show'
          put 'campaigns/:campaign_id/locales/:locale_id/translations/:id',
              to: 'translations#update'
          delete 'campaigns/:campaign_id/locales/:locale_id/translations/:id',
                 to: 'translations#destroy'
        end
        resources :translations do
        end

      end
    end
    root to: redirect('users/sign_in'), as: :unauthenticated_root
  end

  get '*path', to: 'site#index'
  root 'site#index'
end

Rails.application.routes.draw do
  root to: 'home#index'

  get 'home/index'

  devise_for :users, class_name: 'FormUser',
                     controllers: { omniauth_callbacks: 'omniauth_callbacks',
                                    registrations: "registrations" }

  devise_scope :user do
    get '/users/auth/:provider/upgrade' => 'omniauth_callbacks#upgrade', as: :user_omniauth_upgrade
    get '/users/auth/:provider/setup', :to => 'omniauth_callbacks#setup'
  end

  resources :users do
    member do
      resources :posts
      get :following, :followers
    end
  end

  resources :relationships

  get 'post/new', to: 'posts#new'
  get 'post/destroy', to: 'posts#destroy'

end
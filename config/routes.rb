Rails.application.routes.draw do
  mount_roboto
  root 'home#index'
  post 'getlink', to: 'home#getlink'
  get :preview, to: 'home#preview'
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  devise_for :user, controllers: { sessions: 'user/sessions' }, path: '',
                     module: :user,
                     path_names: {
                       sign_up: :signup,
                       sign_in: :login,
                       sign_out: :logout
                     }
  namespace :admin do
    root 'home#index'
    resources :home
  end
  get :about, to: 'home#about'
  get :website, to: 'home#website'
  get :terms, to: 'home#terms'
  get :contact, to: 'home#contact'
  get :use, to: 'home#use'
end

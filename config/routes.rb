Rails.application.routes.draw do
  mount_roboto
  root 'search#index'
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
    resources :blogs do
      collection do
        get :categories, to: 'blogs#categories'
        get :new_categorie, to: 'blogs#new_categorie'
        get 'edit_categorie/:id', to: 'blogs#edit_categorie', as: 'edit_categorie'
        patch 'update_categorie/:id', to: 'blogs#update_categorie', as: 'update_categorie'
        patch :create_categorie, to: 'blogs#create_categorie'
        delete 'destroy_categorie/:id', to: 'blogs#destroy_categorie', as: 'destroy_categorie'
      end
    end
  end
  resources :blogs
  get :about, to: 'home#about'
  get :website, to: 'home#website'
  get :terms, to: 'home#terms'
  get :contact, to: 'home#contact'
  get :use, to: 'home#use'
  post :create_contact, to: 'home#create_contact'
  resources :search
end

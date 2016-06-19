Rails.application.routes.draw do
  mount_roboto
  root 'home#index'
  post 'getlink', to: 'home#getlink'
  get :preview, to: 'home#preview'
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
end

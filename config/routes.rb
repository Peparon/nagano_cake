Rails.application.routes.draw do
  devise_for :customers
  devise_for :admins
  
  namespace :admin do
    get "items/top" => "items#top"
    resources :customers
    resources :items
    resources :genres, only: [:index, :create, :edit, :update]
    resources :orders, only: [:index, :show, :update]
    resources :order_details, only:[:update]
  end
  
  scope module: :customer do
    root 'items#top'
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all'
    get "about" => "items#about"
    get 'orders/thanks' => "orders#thanks"
    post 'orders/confirm'
    
    resources :items
    
    get "items/about" => "items#about"
    resources :customers, only: [:show, :create, :edit, :update] do
      member do
        get "quit"
        patch "withdraw"
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

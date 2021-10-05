Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: { registrations: 'registrations' }
    root 'static_pages#home'
    resources :books, only: [:index]
    resources :users, only: [:show]
    resources :books do 
      resources :comments
    end
    namespace :admin do 
      resources :users do
        collection {post :import}
      end

      resources :books do 
        collection {post :import}
      end
      
      resources :categories do
        collection {post :import}
      end

      root 'dashboard#index'
    end
  end
end

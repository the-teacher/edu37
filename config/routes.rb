JosephStalin::Application.routes.draw do
  root :to => "publications#index"

  # LANG
  match 'lang/:lang' => 'users#lang'

  # PREVIEW
  match "preview/blank",                    :as => "blank",                   :via => [:get, :post]
  match "preview/preview",                  :as => "preview",                 :via => [:get, :post]
  match "preview/preview_with_annotation",  :as => "preview_with_annotation", :via => [:get, :post]

  # USERS
  resources :users do 
    collection{
      get :cabinet
      get :profile
    }
    member{
      post :site_header_upload
      post :avatar_upload
    }
  end
  # PROFILES
  resources :profiles do
    member{
      put :name
      put :avatar
    }
  end
  # PAGES
  resources :pages do 
    collection do
      post  :rebuild
      post  :preview
      get   :manage
      get   :tag
    end
  end
  # PUBLICATIONS aka NEWS
  resources :news, :controller=>'publications' do
    collection do
      post  :rebuild
      post  :preview
      get   :manage
      get   :tag
    end
  end
  # FORUMS
  resources :forums do
    collection do 
      get :manage
    end
    member do
      get :up
      get :down
    end
  end
  #TOPICS
  resources :topics do
    member do
      get :up
      get :down
    end
  end
  # STORAGES
  resources :storages do
    collection do
      post  :rebuild
      get   :manage
      get   :tag
    end
  end
  # UPLOADED FILES
  resources :uploaded_files
  # COMMENTS
  resources :comments do
    collection{
      get :manage
    }
    member{
      post :inplace_edit
      post :inplace_publicate
      post :inplace_undesirable
      post :inplace_delete
    }
  end
  # VOTES
  resources :votes do
    collection do
      post :up
      post :down
      get :test_vote
    end
  end

  # ADMIN =================================================>>>

  namespace :puffer do
    root :to => 'dashboard#index'
    resource :session
  end

  namespace :admin do
    resources :audits     # PUFFER
    resources :tags       # PUFFER
    resources :taggings   # PUFFER
    resources :votes      # PUFFER
    resources :graphs     # PUFFER

    resources :users do
      member do
        post :login_as
      end
    end

    resources :roles do
      member do
        post :new_role_section
        post :new_role_rule
      end
      
      resources :sections, :controller=>'role_section' do
        member do
          get :new_rule
          delete :delete_rule
        end
      end#sections
    end#roles
  end#:admin

  # ROUTES inda development
  resources :roles
  #resources :graphs
  #resources :albums
  resources :audits
  #resources :updates
  resources :messages
  #resources :questions
  #resources :documents
  # PREREG
  resources :preregs do
    member{
      post :invite
    }
  end

  # AUTH
  resource :session, :only => [:new, :create, :destroy]
  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
end

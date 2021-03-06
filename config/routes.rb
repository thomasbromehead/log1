# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#          new_user_session GET    /users/sign_in(.:format)                                                                 devise/sessions#new
#              user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
#      destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
#         new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
#        edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
#             user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
#                           PUT    /users/password(.:format)                                                                devise/passwords#update
#                           POST   /users/password(.:format)                                                                devise/passwords#create
#  cancel_user_registration GET    /users/cancel(.:format)                                                                  devise/registrations#cancel
#     new_user_registration GET    /users/sign_up(.:format)                                                                 devise/registrations#new
#    edit_user_registration GET    /users/edit(.:format)                                                                    devise/registrations#edit
#         user_registration PATCH  /users(.:format)                                                                         devise/registrations#update
#                           PUT    /users(.:format)                                                                         devise/registrations#update
#                           DELETE /users(.:format)                                                                         devise/registrations#destroy
#                           POST   /users(.:format)                                                                         devise/registrations#create
#                      root GET    /                                                                                        pages#home
#              flat_reviews POST   /flats/:flat_id/reviews(.:format)                                                        reviews#create
#                 top_flats GET    /flats/top(.:format)                                                                     flats#top
#                 hote_flat GET    /flats/:id/hote(.:format)                                                                flats#proprio
#                     flats GET    /flats(.:format)                                                                         flats#index
#                           POST   /flats(.:format)                                                                         flats#create
#                  new_flat GET    /flats/new(.:format)                                                                     flats#new
#                 edit_flat GET    /flats/:id/edit(.:format)                                                                flats#edit
#                      flat GET    /flats/:id(.:format)                                                                     flats#show
#                           PATCH  /flats/:id(.:format)                                                                     flats#update
#                           PUT    /flats/:id(.:format)                                                                     flats#update
#                           DELETE /flats/:id(.:format)                                                                     flats#destroy
#               attachinary        /attachinary                                                                             Attachinary::Engine
#               edit_review GET    /reviews/:id/edit(.:format)                                                              reviews#edit
#                    review PATCH  /reviews/:id(.:format)                                                                   reviews#update
#                           PUT    /reviews/:id(.:format)                                                                   reviews#update
#                           DELETE /reviews/:id(.:format)                                                                   reviews#destroy
#          booking_payments POST   /bookings/:booking_id/payments(.:format)                                                 payments#create
#                  bookings GET    /bookings(.:format)                                                                      bookings#index
#                   booking GET    /bookings/:id(.:format)                                                                  bookings#show
#                           DELETE /bookings/:id(.:format)                                                                  bookings#destroy
#             proprio_flats GET    /proprio/flats(.:format)                                                                 proprio/flats#index
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
# 
# Routes for Attachinary::Engine:
#   cors GET  /cors(.:format) attachinary/cors#show {:format=>/json/}

Rails.application.routes.draw do
  devise_for :users
  

  root to: 'pages#home'


  resources :flats do 
    resources :flat_reviews, only: [:create]
    collection do 
      get 'top', to: "flats#top"
    end
    member do 
      get "hote", to: "flats#proprio"
    end
    resources :bookings, only: [:create]
  end
  resources :flat_reviews, only: [:destroy, :edit, :update]

  mount Attachinary::Engine => "/attachinary"


  #Will nest form for creating, and updating a booking on a flat's show page
  resources :bookings, except: [:edit, :update, :new, :create] do
    #New payment will simply be a nested g1 pubkey button
    resources :payments,  only: [:create]
  end

  #namespace for listing an owner's own flats
  namespace :proprio do
    resources :flats, only: [:index]
  end


  # require "sidekiq/web"
  #   authenticate :user, lambda { |u| u.admin } do
  #     mount Sidekiq::Web => '/sidekiq'
  # end

  
    # ...
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end


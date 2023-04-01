Rails.application.routes.draw do
  root "ping#index"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :users, only:[:index, :show] do
        post :login, on: :collection
        member do
          post 'follow'
          delete 'follow', to: 'users#unfollow'
          get 'sleep_records', to: 'users#sleep_records'
        end
      end

      resources :sleep_records, only: [:index] do
        post :clock_in, on: :collection
        post :clock_out, on: :collection
      end
    end
  end
end

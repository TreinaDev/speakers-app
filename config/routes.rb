Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: "users/registrations",
        sessions: "users/sessions"
      }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  get "certificates/:token.pdf", to: "certificates#show", as: :certificate_pdf
  resources :certificates, only: %i[ index ] do
    get 'search', on: :collection
  end
  resources :events, only: %i[ index show ], param: :code
  resources :event_contents, only: %i[ index show new create edit update ], param: :code do
    resources :update_histories, only: %i[ index ]
    member do
      delete 'remove_file/:id', to: 'event_contents#remove_file', as: 'remove_file'
    end
  end

  resources :schedule_items, only: %i[ show ], param: :code do
    post '/answer/:feedback_id', on: :member, as: 'answer', to: 'schedule_items#answer'
  end

  resources :profiles, only: %i[ show new create ], param: :username
  resources :curriculums, only: [], param: :code do
    resources :curriculum_contents, only: %i[ new create show ], param: :code
    resources :curriculum_tasks, only: %i[ new create show ],  param: :code
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :curriculums, only: %i[], param: :schedule_item_code do
        resources :participants, only: %i[ show ], param: :participant_code, to: 'curriculums#show'
      end
      resources :speakers, only: %i[ show ], param: :email, constraints: { email: /[^\/]+/ }
      resources :participant_tasks, only: %i[ create ], params: [ :participant_code, :task_code ]
    end
  end
end

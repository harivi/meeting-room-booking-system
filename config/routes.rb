Rails.application.routes.draw do
  get "home/index"
  # Devise Authentication Routes
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Dashboard Routes
  get "admin_dashboard", to: 'dashboards#admin'
  get "employee_dashboard", to: 'dashboards#employee'

  # Meeting Room Routes (Only Admins Can Access)
  resources :meeting_rooms, except: [:show]

  # Booking Routes (Only Employees Can Access)
  resources :bookings, only: [:index, :new, :create, :destroy] do
    collection do
      get "availability"  # Route for checking room availability
    end
  end

  # Home Page
  root "home#index"
end

Rails.application.routes.draw do
  root 'contacts#index'
  resources :contacts do
    collection do
      post :share
      post :import
    end
  end

end

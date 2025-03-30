Shizit::Application.routes.draw do
	get '/activity', to: 'its#activity'

	resources :its do
		member do
			get 'activity'
		end

		resources :categories do
			resources :contents do
				member do
					get 'pic'
				end
				resources :comments
			end
		end
	end

	devise_for :users

	root to: 'its#show'
end

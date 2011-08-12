InfochimpsExplorer::Application.routes.draw do
  root :to => redirect('http://'+Settings[:host])
  resources :protocols, :id => /.+/ do 
    
  end
  scope '_api_explorer' do
    get 'datasets/:slug/explorer' => 'protocols#explorer'
    get 'datasets/:slug/documentation' => 'protocols#documentation'
  end
  get '/signup' => 'users#new', :as => :signup
  get 'textile' => 'textile#show'
  devise_for :users
end

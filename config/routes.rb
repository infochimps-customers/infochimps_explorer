InfochimpsExplorer::Application.routes.draw do
  resources :protocols, :id => /.+/
  get 'textile' => 'textile#show'
end

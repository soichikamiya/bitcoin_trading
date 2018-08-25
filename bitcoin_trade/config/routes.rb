Rails.application.routes.draw do
  post 'index/set' => 'index#set'
  get 'index/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

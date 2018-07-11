Rails.application.routes.draw do
  get 'comment/evaluate'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'authentication#login', as: :login

  scope 'oauth' do
    get 'begin', to: 'authentication#begin_oauth', as: :begin_oauth
    get 'return', to: 'authentication#end_oauth', as: :end_oauth
    get '/logout', to: 'authentication#logout', as: :logout
  end

  scope 'comments' do
    get 'evaluate', to: 'comment#evaluate', as: :comment
    post 'feedback', to: 'comment#feedback', as: :feedback
  end

  scope 'admin' do
    scope 'database' do
      get 'start', to: 'admin#db_dump', as: :start_dump
    end
  end
end

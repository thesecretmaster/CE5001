Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'authentication#login', as: :login

  scope 'oauth' do
    get 'begin', to: 'authentication#begin_oauth', as: :begin_oauth
    get 'return', to: 'authentication#end_oauth', as: :end_oauth
    get 'logout', to: 'authentication#logout', as: :logout
  end

  get 'dumps', to: 'authentication#db_dumps', as: :db_dumps
  get 'banner/dismiss', to: 'authentication#dismiss_banner', as: :dismiss_banner

  scope 'comments' do
    get 'evaluate', to: 'comment#evaluate', as: :comment
    post 'feedback', to: 'comment#feedback', as: :feedback
    get 'history', to: 'admin#past_reviews', as: :history
    get 'nomore', to: 'comment#done', as: :done
  end

  get 'post/:id', to: 'comment#post_redirect', as: :post

  scope 'admin' do
    scope 'database' do
      get 'start', to: 'admin#db_dump', as: :start_dump
    end
  end
end

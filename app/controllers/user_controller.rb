class UserController < ApplicationController

  get '/signup' do
    erb :"users/create"
  end

  post '/signup' do
    @user = User.create(username: params[:username], password: params[:password])
    @user.email = params[:email] if params[:email] != nil

    if @user.save
      session[:user_id] = @user.id

      redirect "/users/#{@user.slug}"
    else
      erb :"users/create"
    end
  end

  get '/users/:slug' do
    @user = User.find(session[:user_id])
    
    erb :"users/show"
  end

  get '/login' do
    erb :"users/login"
  end

  post '/login' do
    @user = find_user(params)
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "users/#{@user.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
  end

end
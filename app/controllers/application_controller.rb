require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "tacosalad"
  end

  get "/" do
    erb :welcome
  end

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

  get '/login' do
    erb :"users/login"
  end

  post '/login' do
    @user = find_user(params)
    binding.pry
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "users/#{@user.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do

    def current_user
      if session.include?(:user_id)
        @user ||= User.find(session[:user_id])
      end
    end

    def create_user(params)
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    end

    def find_user(params)
      @user = User.find_by(username: params[:username])
    end

  end

end

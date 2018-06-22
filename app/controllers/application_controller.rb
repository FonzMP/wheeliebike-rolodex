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

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
        @current_user ||= User.find(session[:user_id])
      end
    end

    def find_user(params)
      @user = User.find_by(username: params[:username])
    end

  end

end

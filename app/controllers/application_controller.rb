require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "tacosalad"
  end

  get "/" do
    #grabs 'welcome' or 'index' page
    erb :welcome
  end

  helpers do

    def current_user
      #finds current user based on session
      if session.include?(:user_id)
        #locates last instance of current_user if stored, if not, locates current user
        @current_user ||= User.find(session[:user_id])
      end
    end

    def find_user(params)
      # finds user based on params of username being passed in
      @user = User.find_by(username: params[:username])
    end

  end

end

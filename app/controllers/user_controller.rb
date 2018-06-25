class UserController < ApplicationController

  get '/users/:slug' do
    if !current_user
      @error = ["You must be Logged In to see that!"]
      erb :"/users/login"
    else
      @user = User.find_by_slug(params[:slug])
      
      erb :"users/show"
    end
  end

  get '/signup' do
    erb :"users/create"
  end

  post '/signup' do
    @user = User.create(username: params[:username], password: params[:password])
    @user.email = params[:email] if params[:email] != nil

    if @user.save
      session[:user_id] = current_user.id

      redirect "/users/#{current_user.slug}"
    else
      @error = @user.errors.full_messages

      erb :"users/create"
    end
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
      @error = []
      if params[:username].empty?
        @error << "Username can't be blank, please try again."
      else
        if !@user
          @error << "We couldn't find a user with that login, please try again."
        else
          if params[:password].empty?
            @error << "Password can't be blank"
          elsif @user.authenticate(params[:password]) == false
            @error << "That password is not valid, please try again."
          end
        end
      end

      erb  :"users/login"
    end
  end

  get '/logout' do
    session.clear

    redirect '/login'
  end
  
end
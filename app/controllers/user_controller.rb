class UserController < ApplicationController

  get '/users/:slug' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!"]

      erb :"/users/login"
    else
      # locates user by slug passed through params
      @user = User.find_by_slug(params[:slug])
      
      erb :"users/show"
    end
  end

  get '/signup' do
    erb :"users/create"
  end

  post '/signup' do
    # creates new user based on required fields (username and password)
    @user = User.create(username: params[:username], password: params[:password])
    # adds user email if passed
    @user.email = params[:email] if params[:email] != nil

    if @user.save
      # if user saves (is created successfully), sets session user id to equal user id 
      session[:user_id] = @user.id

      redirect "/users/#{current_user.slug}"
    else
      # uses our error instance variable to stay consistent with rest of application, but borrows error messages from activerecord
      @error = @user.errors.full_messages

      erb :"users/create"
    end
  end

  get '/login' do
    erb :"users/login"
  end

  post '/login' do
    # locates user based on username (helper in application controller)
    @user = find_user(params)

    if @user && @user.authenticate(params[:password])
      # if it locates a user, and the user is authenticated using bcrypt, sets session user id
      session[:user_id] = @user.id

      redirect "users/#{@user.slug}"
    else
      # creates error instance variable as an array
      @error = []
      # checks if username is empty. This will override activerecords validation error as they are also validating presence of username
      if params[:username].empty?
        # sets error array to hold message
        @error << "Username can't be blank, please try again."
      else
        # errors to write if no user is located in the DB
        if !@user
          # sets error array to hold message
          @error << "We couldn't find a user with that login, please try again."
        else
          # checks if password field is empty. this will also override activerecords has_secure_password
          if params[:password].empty?
            # sets error array to hold message
            @error << "Password can't be blank"
          elsif @user.authenticate(params[:password]) == false
            # sets error array to hold message
            @error << "That password is not valid, please try again."
          end
        end
      end

      erb  :"users/login"
    end
  end

  get '/logout' do
    # clear user id from session to drop user
    session.clear

    redirect '/login'
  end
  
end
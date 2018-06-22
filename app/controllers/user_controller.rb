class UserController < ApplicationController

  get '/users/:slug' do
    if !current_user
      @error = "You must be Logged In to see that!"
      erb :"/users/login"
    else
      @user = User.find_by_slug(params[:slug])
      
      erb :"users/show"
    end
  end
  
end
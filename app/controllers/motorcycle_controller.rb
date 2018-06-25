class MotorcycleController < ApplicationController

  get '/motorcycles' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      @motorcycles = Motorcycle.all

      erb :"motorcycles/index"
    end
  end

  get '/motorcycles/new' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      erb :"motorcycles/create"
    end
  end

  post '/motorcycles' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"users/login"
    else
      @motorcycle = Motorcycle.create(make: params[:make])
      @error = []

      if @motorcycle.save
        @motorcycle.model = params[:model] if params[:model] != ""
        @motorcycle.year = params[:year] if params[:year] != ""
        @motorcycle.size = params[:size] if params[:size] != ""

        @motorcycle.save

        current_user.motorcycles << @motorcycle
        current_user.save

        redirect '/motorcycles'
      else
        if params[:make].empty?
          @error << "Sorry, make is required to create a new bike. Please try again."
        else
          #this probably won't happen, but good protection
          @error << "Sorry, something went wrong in our system. Please try again."
        end

        erb :"motorcycles/create"
      end
    end
  end

  get '/motorcycles/:id' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])
      @bike_owner = @motorcycle.user.username

      erb :"motorcycles/show"
    end
  end

  get '/motorcycles/:id/edit' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]      
      
      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])
      if current_user.motorcycles.include?(@motorcycle)
        erb :"motorcycles/edit"
      else
        # add an error here saying they don't own the bike
        redirect '/motorcycles'
      end
    end
  end

  patch '/motorcycles/:id' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]      
      
      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])

      @motorcycle.update(make: params[:make]) if params[:make]
      @motorcycle.update(model: params[:model]) if params[:model]
      @motorcycle.update(year: params[:year]) if params[:year]
      @motorcycle.update(size: params[:size]) if params[:size]
      @motorcycle.save

      redirect "/motorcycles/#{@motorcycle.id}"
    end
  end

  delete '/motorcycles/:id' do
    if !current_user
      @error = ["You must be Logged In to see that!", "Please Sign In to delete content"]      
      
      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])
      if current_user.motorcycles.include?(@motorcycle)
        @motorcycle.delete
      end
    end
    redirect "/users/#{current_user.slug}"
  end

end
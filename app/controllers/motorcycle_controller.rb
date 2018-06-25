class MotorcycleController < ApplicationController

  get '/motorcycles' do
    # protection if no current user - does not allow access to individuals that are not logged in
    if !current_user
      # error message being passed
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      # locates all instances of motorcycles
      @motorcycles = Motorcycle.all

      erb :"motorcycles/index"
    end
  end

  get '/motorcycles/new' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      # if user, renders creation form for new motorcycle
      erb :"motorcycles/create"
    end
  end

  post '/motorcycles' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"users/login"
    else
      # creates new instance of motorcycle with only the required params
      @motorcycle = Motorcycle.create(make: params[:make])
      @error = []

      # adds additional key values if passed and motorcycle created successfully
      if @motorcycle.save
        @motorcycle.model = params[:model] if params[:model] != ""
        @motorcycle.year = params[:year] if params[:year] != ""
        @motorcycle.size = params[:size] if params[:size] != ""

        @motorcycle.save

        # adds motorcycle to the current users motorcycle array
        current_user.motorcycles << @motorcycle
        # saves current user to persist data
        current_user.save

        redirect '/motorcycles'
      else
        if params[:make].empty?
          # overrides standard error message for make being empty (make is required)
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
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]

      erb :"/users/login"
    else
      # locates motorcycle by id passed through in params
      @motorcycle = Motorcycle.find(params[:id])
      #locates bike owner for display
      @bike_owner = @motorcycle.user

      erb :"motorcycles/show"
    end
  end

  get '/motorcycles/:id/edit' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]      
      
      erb :"/users/login"
    else
      # locates motorcycle by id passed through in params
      @motorcycle = Motorcycle.find(params[:id])
      # verifies that user owns motorcycle
      if current_user.motorcycles.include?(@motorcycle)
        erb :"motorcycles/edit"
      else
        # should I add an error here saying they don't own the bike - must be rendered through erb - if so, what page do I render?
        redirect '/motorcycles'
      end
    end
  end

  patch '/motorcycles/:id' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to view content"]      
      
      erb :"/users/login"
    else
      # locates motorcycle for patch
      @motorcycle = Motorcycle.find(params[:id])
      # checks that current user owns motorcycle
      if current_user.motorcycles.include?(@motorcycle)
        @motorcycle.update(make: params[:make]) if params[:make]
        @motorcycle.update(model: params[:model]) if params[:model]
        @motorcycle.update(year: params[:year]) if params[:year]
        @motorcycle.update(size: params[:size]) if params[:size]
        @motorcycle.save

        redirect "/motorcycles/#{@motorcycle.id}"
      else
        redirect '/motorcycles'
      end
    end
  end

  delete '/motorcycles/:id' do
    # protection
    if !current_user
      # error
      @error = ["You must be Logged In to see that!", "Please Sign In to delete content"]      
      
      erb :"/users/login"
    else
      # locates motorcycle based on ID passed in in Params
      @motorcycle = Motorcycle.find(params[:id])
      # checks if current user owns motorcycle
      if current_user.motorcycles.include?(@motorcycle)
        # deletes motorcycle
        @motorcycle.delete
      end
    end
    redirect "/users/#{current_user.slug}"
  end

end
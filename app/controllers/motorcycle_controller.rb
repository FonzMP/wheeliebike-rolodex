class MotorcycleController < ApplicationController

  get '/motorcycles' do
    if !current_user
      @error = "You must be Logged In to see that!"
      erb :"/users/login"
    else
      @motorcycles = Motorcycle.all

      erb :"motorcycles/index"
    end
  end

  get '/motorcycles/new' do
    if !current_user
      @error = "You must be Logged In to see that!"
      erb :"/users/login"
    else
      erb :"motorcycles/create"
    end
  end

  post '/motorcycles' do
    @motorcycle = Motorcycle.create(make: params[:make])
    if @motorcycle.save
      @motorcycle.model = params[:model] if params[:model] != ""
      @motorcycle.year = params[:year] if params[:year] != ""
      @motorcycle.size = params[:size] if params[:size] != ""

      @motorcycle.save

      current_user.motorcycles << @motorcycle
      current_user.save

      redirect '/motorcycles'
    else
      erb :"motorcycles/create"
    end
  end

  get '/motorcycles/:id' do
    if !current_user
      @error = "You must be Logged In to see that!"
      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])
      @bike_owner = @motorcycle.user.username

      erb :"motorcycles/show"
    end
  end

  get '/motorcycles/:id/edit' do
    if !current_user
      @error = "You must be Logged In to see that!"
      erb :"/users/login"
    else
      @motorcycle = Motorcycle.find(params[:id])
      if current_user.motorcycles.include?(@motorcycle)
        erb :"motorcycles/edit"
      else
        redirect '/motorcycles'
      end
    end
  end

  patch '/motorcycles/:id' do
    @motorcycle = Motorcycle.find(params[:id])

    @motorcycle.update(make: params[:make]) if params[:make]
    @motorcycle.update(model: params[:model]) if params[:model]
    @motorcycle.update(year: params[:year]) if params[:year]
    @motorcycle.update(size: params[:size]) if params[:size]
    @motorcycle.save

    redirect "/motorcycles/#{@motorcycle.id}"
  end

  delete '/motorcycles/:id' do
    @motorcycle = Motorcycle.find(params[:id])
    if current_user.motorcycles.include?(@motorcycle)
      @motorcycle.delete
    end
    redirect "/users/#{current_user.slug}"
  end

end